#!/usr/bin/env bash
# Push or pull the Home Assistant config over SSH.
# No personal access token is read or written by this script.
# Run inside the Home Assistant container, where the config directory is /config.

set -euo pipefail

REPO_DIR="/config"
REMOTE="git@github.com:salmeister/home-assistant-config.git"
BRANCH="develop-ha"
export GIT_SSH_COMMAND="ssh -i /config/.ssh/ha_deploy_key -o UserKnownHostsFile=/config/.ssh/known_hosts -o IdentitiesOnly=yes"

# Paths this script is allowed to stage. Never `git add .`.
ALLOWLIST=(
  .gitignore
  .github
  .yamllint
  README.md
  configuration.yaml
  automations.yaml
  scripts.yaml
  scenes.yaml
  sensors.yaml
  binary_sensors.yaml
  templates.yaml
  command_line.yaml
  input_booleans.yaml
  input_text.yaml
  lights.yml
  notify.yaml
  secrets_example.yaml
  zones_example.yaml
  blueprints
  packages
  python_scripts
  scripts
  docs
)

usage() {
  echo "usage: $0 push|pull" >&2
  exit 1
}

ensure_ssh_origin() {
  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "${REMOTE}"
  else
    git remote add origin "${REMOTE}"
  fi
}

stage_allowlist() {
  local path
  for path in "${ALLOWLIST[@]}"; do
    if [[ -e "${path}" ]] || git ls-files --error-unmatch -- "${path}" >/dev/null 2>&1; then
      git add -A -- "${path}"
    fi
  done
}

scan_staged() {
  local leak_rc
  set +e
  /config/bin/gitleaks protect --staged --redact --no-banner --config "${REPO_DIR}/scripts/gitleaks.toml"
  leak_rc=$?
  set -e
  if [[ "${leak_rc}" -eq 0 ]]; then
    return 0
  fi
  git reset --quiet
  if [[ "${leak_rc}" -eq 1 ]]; then
    echo "gitleaks found a secret in the staged changes; the index was reset" >&2
    exit 2
  fi
  echo "gitleaks failed with exit ${leak_rc}; the index was reset" >&2
  exit "${leak_rc}"
}

mode="${1:-}"
if [[ $# -ne 1 ]]; then
  usage
fi

cd "${REPO_DIR}"
ensure_ssh_origin

case "${mode}" in
  push)
    # Drop anything already staged so a previous `git add .` cannot be committed.
    git reset --quiet
    stage_allowlist
    if git diff --cached --quiet; then
      # Nothing new to commit. If an earlier commit never reached origin,
      # publish that commit; otherwise exit 0 without making a new one.
      if git rev-parse --verify --quiet "refs/remotes/origin/${BRANCH}" >/dev/null \
        && [[ "$(git rev-list --count "origin/${BRANCH}..HEAD")" != "0" ]]; then
        git push origin "HEAD:${BRANCH}"
      fi
      exit 0
    fi
    scan_staged
    files=""
    while IFS= read -r path; do
      files="${files:+${files} }${path}"
    done < <(git diff --cached --name-only)
    git commit -m "[ha-ui] ${files}"
    git push origin "HEAD:${BRANCH}"
    ;;
  pull)
    git fetch origin "${BRANCH}"
    git pull --ff-only origin "${BRANCH}"
    ;;
  *)
    usage
    ;;
esac
