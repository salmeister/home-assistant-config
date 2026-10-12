# 🏠 Home Assistant Configuration

Welcome to my Home Assistant configuration! This repository showcases a smart home setup with advanced automations, integrations, and custom solutions that have evolved over years of refinement.

## 🌟 Highlights

- **🤖 Advanced AI Integration**: Frigate camera system with face recognition and GenAI descriptions
- **🚗 Smart Garage Management**: Comprehensive garage door automation with actionable notifications
- **🎯 Intelligent Lighting**: Zone-based lighting with automated schedules and presence detection
- **📱 Rich Mobile Notifications**: Actionable notifications with images, videos, and smart actions
- **🔊 Voice Control**: Google Assistant integration with custom commands and hub displays
- **📊 Custom Sensors**: Python scripts for light level calculation and state management
- **🔒 Security Automation**: Multi-layered security with external/internal armed modes

## 🏗️ Architecture

### Core Configuration Files

| File | Purpose | Key Features |
|------|---------|--------------|
| `automations.yaml` | Smart home logic | 60+ automations including garage security, lighting, notifications |
| `scripts.yaml` | Reusable actions | Notification scripts, light control, utility functions |
| `sensors.yaml` | Custom sensors | Device tracking, usage monitoring, external light level calculation |
| `scenes.yaml` | Predefined states | Lighting scenes, security modes, entertainment setups |
| `configuration.yaml` | Main config | Integration setup, includes, basic settings |

### Advanced Features

#### 🚗 Garage Door System
- **Real-time Person Detection**: Frigate integration with face recognition
- **AI-Powered Notifications**: GenAI descriptions of garage activities
- **Smart Security**: Different behaviors when armed vs. home
- **Actionable Mobile Alerts**: View clips, close garage, dismiss notifications
- **Status Indicators**: Back entry light changes to red when garage is open
- **Voice Control**: "Hey Google, close the garage door" integration

#### 💡 Intelligent Lighting
- **Zone-Based Control**: Different lighting behaviors for basement, main floor, outdoor areas
- **Presence Detection**: Automatic on/off based on occupancy and time of day
- **Always-On Management**: Z-Wave switches that maintain power for smart bulbs
- **Smart Scenes**: Dawn/Dusk lighting with custom brightness levels
- **Motion-Based Automation**: Lights respond to room occupancy sensors

#### 📹 Frigate Camera Integration
- **Multi-Camera Setup**: Front porch, garage, and additional security cameras
- **Person Recognition**: Face detection with named identification
- **Smart Notifications**: Context-aware alerts with snapshots and video clips
- **Zone Filtering**: Only alert for specific areas (front walk, garage entry)

#### 🔐 Security & Monitoring
- **Tiered Security Modes**: 
  - External Armed: Monitors outdoor cameras and entry points
  - Full Armed: Complete home monitoring when away
  - Home Mode: Reduced sensitivity for normal occupancy
- **Smart Notifications**: Different alert types based on security level
- **Device Monitoring**: Track phone usage, presence, and device states

## 🛠️ Technical Implementation

### Custom Python Scripts
```
python_scripts/
├── calc_light_level.py     # Weather-based light level calculation (foundation for future automation)
└── set_state.py           # Dynamic entity state management
```

### Blueprint Integrations
- **Frigate Notifications**: Enhanced camera alert system
- **Vacation Lighting**: Randomized lighting patterns when away
- **Low Battery Detection**: Automatic monitoring of all battery-powered devices
- **Actionable Notifications**: Custom notification templates with actions

### Advanced Automations

#### Garage Door Security (`automations.yaml`)
```yaml
# Enhanced person detection with AI and face recognition
- Enhanced Garage Door Person Detection
- Handle Enhanced Garage Actions
- Google Assistant Garage Voice Control
```

#### Smart Lighting (`automations.yaml`) 
```yaml
# Sun-based lighting with scene automation
- Dawn Settings: Sunrise-triggered scene activation
- Dusk Settings: Sunset-triggered scene with garage notifications
- Zone-specific automation for different areas
- Always-on switch management for smart bulbs
```

## 🚀 Getting Started

### Prerequisites
- Home Assistant 2024.10+ (required for latest Frigate integration)
- MQTT Broker (for Frigate communication)
- Frigate NVR system (for camera features)
- Google Assistant SDK (for voice control)
- Z-Wave network (for switch management)

### Installation

**Install required integrations**:
   - [Frigate Integration](https://github.com/blakeblackshear/frigate-hass-integration)
   - [Google Assistant SDK](https://www.home-assistant.io/integrations/google_assistant_sdk/)
   - [Mobile App](https://companion.home-assistant.io/)

### Key Configuration Steps

#### Frigate Camera Setup
Update camera names and zones in automations to match your Frigate configuration:
```yaml
# In automations.yaml, update camera name from 'garage' to your camera
camera == 'your_camera_name'
```

#### Mobile Notifications
Replace device IDs with your mobile app device IDs:
```yaml
# Find your device ID in Home Assistant > Settings > Devices
action: notify.mobile_app_your_device_id
```

#### Google Assistant
Configure your Google Assistant integration and update hub names:
```yaml
# Update with your actual Google Hub device names
target:
  - your_kitchen_hub
  - your_bedroom_hub
```

## 📱 Mobile App Features

### Actionable Notifications
- **Garage Alerts**: View clip, close garage, dismiss
- **Security Alerts**: Acknowledge, view camera, arm/disarm
- **Device Monitoring**: Battery warnings, maintenance reminders

### Rich Media
- **Embedded Images**: Camera snapshots directly in notifications
- **Video Clips**: Quick access to relevant footage
- **Live Streams**: Direct links to camera feeds

## 🔧 Customization Tips

### Adding New Cameras
1. Add camera to Frigate configuration
2. Create new automation based on garage door template
3. Update camera name and notification preferences
4. Test with your specific zones and objects

### Extending Notifications
1. Copy existing notification automation
2. Modify triggers for your use case
3. Customize message templates and actions
4. Add device-specific targeting

### Creating Custom Sensors
1. Use `python_scripts/` examples as templates
2. Create new sensors in `sensors.yaml`
3. Reference in automations for smart decisions
4. Test with Home Assistant's template editor

## 🤝 Contributing

Found something useful? Have improvements? 

- ⭐ Star the repository if you find it helpful
- 🐛 Report issues with specific configurations
- 💡 Share your adaptations and improvements
- 📝 Suggest documentation improvements

## 📊 Statistics

- **60+ Automations**: Covering security, lighting, notifications, device management
- **15+ Custom Sensors**: Device monitoring, usage tracking, external light level foundation  
- **Multiple Integrations**: Frigate, Google Assistant, Z-Wave, MQTT
- **Advanced Features**: Face recognition, AI descriptions, actionable notifications
- **3+ Years**: Continuous refinement and optimization

## �️ Installation & Setup

### Prerequisites
- Home Assistant Core/Supervised/OS installation
- Git configured with repository access
- Network access for GitHub repository sync

### GitHub Configuration Management

Sync uses an SSH deploy key and `scripts/ha-git-sync.sh`. Setup, the nightly
push, and the pull button are documented in [`docs/git-sync.md`](docs/git-sync.md).
Do not put a personal access token in the container or in shell commands.

`entity_registry_snapshot.json`, `lovelace_raw_configuration.yaml`,
`.HA_VERSION`, and `.ha_run.lock` hold MAC addresses and household data and are
no longer published. They remain on the Home Assistant host and are gitignored.

## �🙏 Acknowledgments

- **Home Assistant Community**: For endless inspiration and support
- **Frigate Project**: For the best local NVR solution
- **SgtBatten**: For excellent notification blueprints
- **Blueprint Contributors**: For sharing automation templates

## 📄 License

This configuration is shared under MIT License. Feel free to use, modify, and adapt for your own smart home!

---

*This repository represents a real-world, production Home Assistant setup that balances automation sophistication with reliability and maintainability.*

## 🔒 Security & Privacy (Public Repo)

This is a public repository. Do not store sensitive information here.

- Use `!secret` for all credentials and sensitive data (coordinates, tokens, API keys, webhook IDs, Wi‑Fi PSKs, service account files). Keep real values in `secrets.yaml` (already git‑ignored).
- Avoid publishing exact addresses, GPS coordinates, precise schedules, or personally identifying details. Prefer area names and pseudonyms.
- Never commit URLs with embedded credentials (RTSP/HTTP/MQTT). Use separate `!secret` entries for user, password, and hosts.
- Before committing, scan changes for risky terms like: password, token, api_key, secret, webhook, bearer, authorization, latitude, longitude.
- See `docs/memory.md` → Security & privacy guardrails for examples and redaction guidance.

## Unpublished household files

`entity_registry_snapshot.json`, `lovelace_raw_configuration.yaml`,
`.HA_VERSION`, and `.ha_run.lock` hold MAC addresses and household data and are
no longer published. Do not add them back to git. See
[`docs/git-sync.md`](docs/git-sync.md).

