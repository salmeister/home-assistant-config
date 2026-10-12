# Git sync

Home Assistant runs in Docker with its configuration directory at `/config`.
This repository is public. Sync uses an SSH deploy key. There is no
`GITHUB_TOKEN` and no personal access token in the container, the shell
commands, or this repository.

`entity_registry_snapshot.json`, `lovelace_raw_configuration.yaml`,
`.HA_VERSION`, and `.ha_run.lock` are not published. They hold MAC addresses
and other household data. They stay on the Home Assistant host and are ignored
by git.

## One-time setup

Run these commands inside the Home Assistant container.

### Deploy key

```bash
mkdir -p /config/.ssh /config/bin
chmod 700 /config/.ssh
ssh-keygen -t ed25519 -N '' -f /config/.ssh/ha_deploy_key
chmod 600 /config/.ssh/ha_deploy_key
```

GitHub → this repository → Settings → Deploy keys → Add deploy key. Paste
`/config/.ssh/ha_deploy_key.pub`. Enable write access. A deploy key is not a
personal access token.

```bash
known_hosts_tmp="$(mktemp)"
trap 'rm -f "$known_hosts_tmp"' EXIT
ssh-keyscan -t ed25519 github.com > "$known_hosts_tmp"
fingerprint="$(ssh-keygen -lf "$known_hosts_tmp" -E sha256 | awk '{print $2}')"
if [ "$fingerprint" != "SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU" ]; then
  echo "GitHub SSH host key fingerprint did not match; refusing to trust it." >&2
  exit 1
fi
install -m 600 "$known_hosts_tmp" /config/.ssh/known_hosts
rm "$known_hosts_tmp"
trap - EXIT
```

The fingerprint above is GitHub's published ED25519 host key fingerprint.
Check [GitHub's SSH key fingerprints](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)
if GitHub rotates its host key.

Point the config remote at SSH. This replaces an HTTPS remote, including one
that embedded a token:

```bash
cd /config
git remote set-url origin git@github.com:salmeister/home-assistant-config.git
git config user.name "Home Assistant"
git config user.email "homeassistant@example.com"
```

`scripts/ha-git-sync.sh` also sets `origin` to that SSH URL before push or pull.

### gitleaks

Install the static gitleaks binary at `/config/bin/gitleaks`. `bin/` is not
allowlisted, so the binary is not committed.

```bash
arch="$(uname -m)"
case "${arch}" in
  x86_64) asset="linux_x64" ;;
  aarch64|arm64) asset="linux_arm64" ;;
  *) echo "unsupported architecture: ${arch}" >&2; exit 1 ;;
esac
version="8.30.1"
curl -fsSL -o /tmp/gitleaks.tar.gz \
  "https://github.com/gitleaks/gitleaks/releases/download/v${version}/gitleaks_${version}_${asset}.tar.gz"
tar -xzf /tmp/gitleaks.tar.gz -C /config/bin gitleaks
chmod 755 /config/bin/gitleaks
rm /tmp/gitleaks.tar.gz
/config/bin/gitleaks version
```

### Remove the personal access token

Delete `GITHUB_TOKEN` from the Home Assistant container environment (compose
file, run script, or add-on config) and recreate the container. Then revoke
that token: GitHub → Settings → Developer settings → Personal access tokens.
The push path no longer reads it.

### Local files

```bash
cp /config/secrets_example.yaml /config/secrets.yaml
cp /config/zones_example.yaml /config/zones.yaml
```

Edit `secrets.yaml` with the real values. Edit `zones.yaml` with the real
zones (coordinates stay in that gitignored file). Both files are included by
`configuration.yaml` and are not published. `secrets_example.yaml` only
contains obvious dummy values.

### GitHub secret scanning

GitHub → this repository → Settings → Code security. Enable Secret scanning
and Push protection. Historical commits still contain the old snapshot files.
Do not rewrite history. Review alerts on those old commits and dismiss the
ones that refer to files removed from the current tree.

## What gets committed

`scripts/ha-git-sync.sh push` stages only the allowlist in `.gitignore`
(configuration YAML, `blueprints/`, `packages/`, `python_scripts/`, `scripts/`,
`docs/`, and the example secret/zone files). It never runs `git add .`.

Before the commit it runs:

```bash
/config/bin/gitleaks protect --staged --config /config/scripts/gitleaks.toml
```

The config extends the default gitleaks rules and also flags:

- `wifi_password` / `wifi password` / `ota_password` set to a literal value
  (a `!secret` reference is allowed)
- `healthchecks.<domain>/<uuid>` and `hc-ping.com/<uuid>` URLs
- `192.168.x.x` addresses
- MAC addresses

If gitleaks reports a finding it resets the index and exits 2. Nothing is
committed. If nothing is staged, the script exits 0. A local commit that
never reached `origin/develop-ha` is checked before it is pushed. Immediately
before either push, the script checks every outgoing commit for paths outside
the publishing allowlist and scans the outgoing Git history with gitleaks.
Otherwise it commits with the message `[ha-ui] <files>` and pushes
`develop-ha` over SSH.

`scripts/ha-git-sync.sh pull` runs `git fetch origin develop-ha` and
`git pull --ff-only origin develop-ha`. A diverged branch fails instead of
merging or rebasing. Do not force-push.

## Using it

Shell commands in `configuration.yaml`:

- `shell_command.git_sync_push` runs `push`
- `shell_command.git_sync_pull` runs `pull`

Scripts:

- **Sync config to GitHub now** (`script.sync_config_to_github`) runs the push
  command and posts a persistent notification for success or failure.
- **Git Sync Changes** (`script.git_sync_changes`) is the existing pull button.
  It pulls, runs `homeassistant.check_config`, and reloads automations,
  scripts, and scenes only when the check passes. It notifies either way.
  `input_boolean.github_operation_error` is turned off at the start and turned
  on if the pull or the config check fails.

Automation **Nightly Git sync push** (`nightly_git_sync_push`) runs the push
command at 03:17. The config changes rarely, so this is the only schedule.
There is no frequent timer. A nonzero exit turns on
`input_boolean.github_operation_error` and posts a persistent notification.
Exit 0 with nothing to commit is success.

The command-line sensor **GitHub Config Updates Available** counts commits
between the local checkout and `develop-ha` on GitHub. The old **Config
Snapshots Changes Available** sensor and `scripts/update-config-snapshots.sh`
are gone.

## If a push is rejected

A rejected push usually means GitHub is ahead, or gitleaks / push protection
blocked a secret. Pull with the Git Sync Changes script (fast-forward only),
fix the finding locally, and push again. Do not force-push and do not put the
secret behind a `!secret` line that still contains the literal value.
