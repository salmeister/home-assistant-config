# 🏠 Smart Home Assistant Configuration

Welcome to my comprehensive Home Assistant configuration! This repository showcases a sophisticated smart home setup with advanced automations, integrations, and custom solutions that have evolved over years of refinement.

## 🌟 Highlights

- **🤖 Advanced AI Integration**: Frigate camera system with face recognition and GenAI descriptions
- **🚗 Smart Garage Management**: Comprehensive garage door automation with actionable notifications
- **🎯 Intelligent Lighting**: Zone-based lighting with automated schedules and presence detection
- **📱 Rich Mobile Notifications**: Actionable notifications with images, videos, and smart actions
- **🔊 Voice Control**: Google Assistant integration with custom commands and hub displays
- **📊 Custom Sensors**: Python scripts for intelligent light level calculation and state management
- **🔒 Security Automation**: Multi-layered security with external/internal armed modes

## 🏗️ Architecture

### Core Configuration Files

| File | Purpose | Key Features |
|------|---------|--------------|
| `automations.yaml` | Smart home logic | 60+ automations including garage security, lighting, notifications |
| `scripts.yaml` | Reusable actions | Notification scripts, light control, utility functions |
| `sensors.yaml` | Custom sensors | Weather-based light levels, device tracking, usage monitoring |
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
- **Weather-Aware Automation**: Custom Python script calculates light levels based on sun elevation and cloud coverage
- **Zone-Based Control**: Different lighting behaviors for basement, main floor, outdoor areas
- **Presence Detection**: Automatic on/off based on occupancy and time of day
- **Always-On Management**: Z-Wave switches that maintain power for smart bulbs

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
├── calc_light_level.py     # Weather-based light level calculation
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
# Weather-aware lighting with custom sensors
- Light level calculation based on sun elevation and cloud coverage
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

1. **Clone the repository**:
   ```bash
   git clone https://github.com/salmeister/home-assistant-config.git
   ```

2. **Adapt to your setup**:
   - Update device names in `automations.yaml`
   - Modify camera names in Frigate configurations
   - Adjust notification targets for your mobile devices
   - Configure your Z-Wave device IDs

3. **Install required integrations**:
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
- **15+ Custom Sensors**: Weather awareness, device monitoring, usage tracking  
- **Multiple Integrations**: Frigate, Google Assistant, Z-Wave, MQTT
- **Advanced Features**: Face recognition, AI descriptions, actionable notifications
- **3+ Years**: Continuous refinement and optimization

## 🙏 Acknowledgments

- **Home Assistant Community**: For endless inspiration and support
- **Frigate Project**: For the best local NVR solution
- **SgtBatten**: For excellent notification blueprints
- **Blueprint Contributors**: For sharing automation templates

## 📄 License

This configuration is shared under MIT License. Feel free to use, modify, and adapt for your own smart home!

---

*This repository represents a real-world, production Home Assistant setup that balances automation sophistication with reliability and maintainability.*

