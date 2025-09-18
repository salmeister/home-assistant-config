# GitHub Copilot Instructions for Home Assistant Configuration

## Repository Overview

This is a comprehensive Home Assistant configuration repository featuring advanced automation, security monitoring, intelligent lighting, and smart home integrations. The configuration has been refined over 3+ years and includes 60+ automations, Frigate camera integration with AI, actionable mobile notifications, and sophisticated garage door management.

## Critical First Steps

### 1. ALWAYS Read Memory File First
**MANDATORY**: Before any task, question, or suggestion, ALWAYS read `docs/memory.md` to understand:
- Latest chat history and ongoing context
- Recent discoveries and completed tasks
- Current project state and active issues
- Existing entity relationships and automation patterns
- Previously documented solutions and approaches

This prevents repetitive work, maintains continuity, and leverages previous insights.

### 2. Always Review Entity Registry
**ESSENTIAL**: After reading memory, review the `entity_registry_snapshot.json` file to understand:
- All available sensors, switches, lights, and other entities
- Area assignments for each entity (kitchen, garage, basement, etc.)
- Entity states, capabilities, and device relationships
- Platform integrations (Z-Wave, Frigate, Rachio, etc.)

```bash
# Always start with this command after reading memory
cat entity_registry_snapshot.json | jq '.data.entities[] | {entity_id, area_id, original_name, platform}'
```

This file is updated regularly and contains the authoritative source of truth for all Home Assistant entities and their locations.

### 3. Memory Management System
**REQUIRED**: This repository includes a memory system for maintaining context across interactions:

- **Location**: `docs/memory.md` 
- **Purpose**: Store ongoing context, task progress, entity relationships, and configuration decisions
- **Usage**: Read from and write to this file throughout any multi-step process
- **Management**: Create if missing, update regularly, delete obsolete information

**Always**:
1. Read `docs/memory.md` at the start of any substantial task
2. Update memory with new findings, decisions, and progress
3. Reference memory when making related changes
4. Clean up completed tasks from memory

## Repository Structure & Key Files

### Core Configuration Files
- `configuration.yaml` - Main configuration with includes and integrations
- `automations.yaml` - 60+ smart home automations (primary logic)
- `scripts.yaml` - Reusable action scripts and notifications
- `sensors.yaml` - Custom sensors and device monitoring
- `scenes.yaml` - Predefined lighting and security states
- `entity_registry_snapshot.json` - **CRITICAL**: Complete entity inventory with areas

### Specialized Directories
- `blueprints/` - Community and custom automation blueprints
- `python_scripts/` - Custom Python logic for light calculation and state management
- `docs/` - Documentation and memory management
  - `frigate-reference.md` - Frigate integration patterns and MQTT topics
  - `companion-app-reference.md` - Mobile app notifications and actionable patterns
  - `memory.md` - Context and task tracking
- `scripts/` - Shell scripts for repository management

### Area Mapping (from entity registry)
Key areas in the home based on entity assignments:
- `kitchen` - Kitchen appliances, dishwasher notifications
- `garage` - Garage door security, person detection
- `basement` - Water detection, temperature monitoring
- `master_bedroom` - Bedroom lighting and controls
- `laundry_room` - Laundry monitoring, water sensors
- `porch` - Dog feeding automation
- `back_entry` - Door locks and entry security

## Advanced Features & Integrations

### 🚗 Garage Door System (Priority Feature)
- **Frigate Integration**: AI-powered person detection with face recognition
- **Security Automation**: Different behaviors when armed vs. home
- **Actionable Notifications**: Mobile alerts with video clips and garage control using companion app
- **Voice Control**: Google Assistant integration
- **Visual Indicators**: Back entry light status changes

**Key Entities** (verify in entity_registry_snapshot.json):
- Garage door sensors and controls
- Frigate camera entities for garage
- Person detection binary sensors
- Mobile notification targets (SALMOB1, SALMOB2 for parents)

### 💡 Intelligent Lighting
- **Zone-Based Control**: Area-specific lighting logic
- **Scene Automation**: Dawn/Dusk settings with time-based triggers
- **Always-On Management**: Z-Wave switches maintaining power for smart bulbs
- **Presence Detection**: Motion-based activation

### 📹 Frigate Camera Integration
- **Multi-Camera Setup**: Front porch, garage, security cameras
- **AI Notifications**: GenAI descriptions of detected activities
- **Zone Filtering**: Area-specific detection logic
- **Face Recognition**: Named person identification

### 🔐 Security & Monitoring
- **Tiered Security Modes**: External armed, full armed, home mode
- **Water Detection**: Multiple sensors in basement, kitchen, laundry
- **Temperature Monitoring**: Low temperature alerts
- **Device Health**: Battery monitoring, connectivity status

## Home Assistant Core Technologies

Home Assistant primarily uses three key technologies for configuration and operation:

### 🔧 Jinja2 Templating
- **Documentation**: https://www.home-assistant.io/docs/configuration/templating/
- **Purpose**: Dynamic configuration, conditions, and data processing
- **Usage**: State templates, conditional logic, data transformation in automations and scripts
- **Key Features**: State access, time functions, mathematical operations, string manipulation
- **Common Patterns**: `{{ states('entity_id') }}`, `{{ state_attr('entity_id', 'attribute') }}`, `{% if condition %}...{% endif %}`

### 📝 YAML Configuration
- **Documentation**: https://www.home-assistant.io/docs/configuration/yaml/
- **Purpose**: Primary configuration language for all Home Assistant components
- **Critical Rules**: Indentation-sensitive, case-sensitive, supports includes and packages
- **Best Practices**: Use consistent indentation (2 spaces), avoid tabs, validate syntax regularly
- **Advanced Features**: Anchors and references, multi-line strings, includes, packages

### 🖥️ Lovelace Dashboards
- **Documentation**: https://www.home-assistant.io/dashboards/
- **Purpose**: Frontend UI configuration for user interfaces
- **Configuration**: YAML-based dashboard definitions with card-based layout
- **Features**: Custom cards, themes, responsive design, mobile optimization
- **Storage**: Can be configured via UI (stored in `.storage/`) or YAML files

## Development Guidelines

### Before Making Changes
1. **Read Memory**: Check `docs/memory.md` for context
2. **Review Entity Registry**: Understand available entities and their areas
3. **Check Dependencies**: Understand automation relationships
4. **Reference Documentation**: Use `docs/frigate-reference.md` for camera/MQTT integrations and `docs/companion-app-reference.md` for mobile notifications
5. **Consult Core Technologies**: 
   - **Jinja2 Templates**: https://www.home-assistant.io/docs/configuration/templating/
   - **YAML Configuration**: https://www.home-assistant.io/docs/configuration/yaml/
   - **Lovelace Dashboards**: https://www.home-assistant.io/dashboards/
6. **Consult HA Documentation**: For integration-specific features, configuration syntax, or new functionality, search the official [Home Assistant documentation](https://www.home-assistant.io/docs/) 
7. **Backup Approach**: Always maintain working configuration

### Entity Management
- Use entity registry to identify correct entity IDs
- Respect area assignments when creating area-specific automations
- Verify entity capabilities before referencing in automations
- Consider platform limitations (Z-Wave, WiFi, etc.)

### Automation Development
- Follow existing patterns in `automations.yaml`
- Use meaningful, descriptive automation names
- Include proper conditions to prevent unwanted triggers
- Test with Home Assistant's automation trace feature

### Script Development
- Store reusable logic in `scripts.yaml`
- Use scripts for complex notification workflows
- Parameterize scripts for flexibility across automations
- Follow notification best practices for mobile apps (see `docs/companion-app-reference.md`)
- Implement proper `mobile_app_notification_action` event handling for actionable notifications

### Blueprint Usage
- Check existing blueprints in `blueprints/` before creating new automations
- Customize blueprint inputs for specific use cases
- Document blueprint modifications in memory

## Home Assistant Documentation Strategy

### When to Create Local References
Create reference documents for:
- **Stable Integration Patterns**: Systems heavily used in this configuration (Frigate, Companion App)
- **Complex Implementations**: Multi-step processes with system-specific customizations
- **Cross-Reference Needs**: Information that combines multiple HA integrations
- **Troubleshooting Patterns**: Common issues and solutions specific to this setup

### When to Search Official HA Documentation  
Search [Home Assistant docs](https://www.home-assistant.io/docs/) directly for:
- **New Integration Features**: Recently added capabilities or configuration options
- **Syntax Changes**: Updated YAML formats, action names, or parameters
- **Entity Types**: New entity domains or state/attribute definitions
- **Platform Updates**: Changes in core functionality or breaking changes
- **Integration Specifics**: Detailed configuration for integrations not heavily customized here

### Documentation Search Strategy
1. **Start with [HA Glossary](https://www.home-assistant.io/docs/glossary/)** for core concept clarification
2. **Use Integration Pages** (`/integrations/<name>`) for specific device/service configuration
3. **Check [Automation](https://www.home-assistant.io/docs/automation/) and [Scripts](https://www.home-assistant.io/docs/scripts/)** for action syntax and trigger patterns
4. **Reference [Templates](https://www.home-assistant.io/docs/configuration/templating/)** for Jinja2 syntax and functions
5. **Search Release Notes** for breaking changes and new features affecting existing configurations

### Key HA Documentation Sections
- **Configuration**: Entity management, YAML structure, packages
- **Automations**: Triggers, conditions, actions, and templating
- **Dashboards**: UI configuration and card types
- **Integrations**: Platform-specific setup and configuration
- **Organization**: Areas, labels, floors, and device management

### Quick Reference Links

#### Home Assistant Core Technologies
- **[Jinja2 Templating](https://www.home-assistant.io/docs/configuration/templating/)** - Dynamic templates, conditions, and data processing
- **[YAML Configuration](https://www.home-assistant.io/docs/configuration/yaml/)** - Primary configuration syntax and best practices
- **[Lovelace Dashboards](https://www.home-assistant.io/dashboards/)** - Frontend UI configuration and card-based layouts

#### General Documentation
- [HA Glossary](https://www.home-assistant.io/docs/glossary/) - Core concepts and terminology
- [Automation Actions](https://www.home-assistant.io/docs/automation/action/) - Action syntax and examples
- [Entity Organization](https://www.home-assistant.io/docs/organizing/) - Areas, labels, floors
- [Release Notes](https://www.home-assistant.io/blog/categories/release-notes/) - Monthly updates and breaking changes

## Integration-Specific Guidance

### Companion App Mobile Notifications
- **Device Awareness**: 4 Android devices (SALMOB1, SALMOB2, SALMOB4, SALMOB5) + 1 iOS device (SALMOB3)
- **Action Limits**: Android max 3 actions, iOS max ~10 actions
- **Platform Features**: iOS supports SF Symbols icons and destructive actions; Android requires `action: URI` for URIs
- **Notification Groups**: Use `parent_mobile_devices` for security alerts, `all_android_devices`/`all_apple_devices` for platform-specific features
- **Event Handling**: All actionable notifications must have corresponding `mobile_app_notification_action` event automation
- **Best Practices**: Use unique action IDs with context to prevent conflicts, implement timeouts for temporary notifications
- **Reference**: See `docs/companion-app-reference.md` for complete implementation patterns and examples

### Frigate Camera System
- Camera names must match Frigate configuration
- Zone detection uses specific area names
- Person detection requires proper entity mapping
- Mobile notifications need device-specific targeting

### Home Assistant Companion App
- **4 Android devices** (SALMOB1, SALMOB2, SALMOB4, SALMOB5) + **1 iOS device** (SALMOB3)
- Android notifications limited to 3 actions; iOS supports ~10 actions
- Use notification groups: `all_android_devices`, `all_apple_devices`, `all_mobile_devices`, `parent_mobile_devices`
- Actionable notifications require `mobile_app_notification_action` event handling
- iOS supports SF Symbols icons (`sfsymbols:icon`); Android URI actions need `action: URI`
- Reference `docs/companion-app-reference.md` for detailed implementation patterns

### Google Assistant SDK
- Voice commands require proper device targeting
- Hub names must match actual Google devices
- Response feedback should be area-appropriate

### Z-Wave Network
- Always-on switches maintain power for smart bulbs
- Z-Wave node management affects automation reliability
- Consider mesh network topology for new devices

### Mobile App Integration
- Device IDs must match actual mobile app registrations
- Rich notifications require proper media paths
- Actionable notifications need corresponding automation event handlers
- Platform differences: Android (3 actions max) vs iOS (10 actions, SF Symbols)
- Use notification groups to target appropriate devices efficiently

## Common Patterns

### Jinja2 Template Patterns
```yaml
# State checks and conditional logic
condition:
  - condition: template
    value_template: "{{ states('sensor.temperature') | float > 70 }}"

# Time-based conditions
condition:
  - condition: template
    value_template: "{{ now().hour >= 8 and now().hour <= 22 }}"

# Entity attribute access
value_template: "{{ state_attr('climate.thermostat', 'current_temperature') }}"

# Mathematical operations
value_template: "{{ (states('sensor.power') | float * 0.001) | round(2) }}"

# String manipulation and filtering
message: "{{ states.sensor | selectattr('state', 'eq', 'on') | list | count }} sensors are active"
```

### YAML Configuration Patterns
```yaml
# Using anchors and references for reusable configs
common_notification: &notification_base
  service: notify.mobile_app_device
  data:
    title: "Home Assistant Alert"

# Include files for organization
automation: !include automations.yaml
script: !include scripts.yaml
sensor: !include_dir_merge_list sensors/

# Multi-line strings
message: |
  This is a multi-line message
  that preserves line breaks
  for better readability.

# Conditional includes
automation: !include_dir_merge_list automations/
```

### Lovelace Dashboard Patterns
```yaml
# Card-based layout
type: vertical-stack
cards:
  - type: entities
    title: "Climate Control"
    entities:
      - climate.thermostat
      - sensor.temperature
      
  - type: glance
    title: "Quick Controls"
    entities:
      - light.living_room
      - switch.fan

# Conditional cards
type: conditional
conditions:
  - entity: binary_sensor.motion
    state: "on"
card:
  type: picture-entity
  entity: camera.front_door
```

### Notification Workflows
```yaml
# Standard notification pattern with companion app actions
- service: notify.mobile_app_device
  data:
    title: "Descriptive Title"
    message: "Clear, actionable message"
    data:
      tag: "unique_identifier"
      group: "category_name"
      persistent: true
      image: "/path/to/image"
      actions:
        - action: "ACTION_IDENTIFIER"
          title: "Action Button"
          # Platform-specific options
```

# Companion app event handling
- platform: event
  event_type: mobile_app_notification_action
  event_data:
    action: "ACTION_IDENTIFIER"
```

### Area-Based Automation
```yaml
# Use area_id from entity registry
trigger:
  - platform: state
    entity_id: binary_sensor.area_specific_sensor
condition:
  - condition: state
    entity_id: input_boolean.area_automation_enabled
    state: 'on'
```

### Security Mode Logic
```yaml
# Respect security states
condition:
  - condition: or
    conditions:
      - condition: state
        entity_id: alarm_control_panel.home_security
        state: 'armed_away'
      - condition: state
        entity_id: alarm_control_panel.home_security
        state: 'armed_home'
```

## Troubleshooting Guidelines

### Common Issues
1. **Entity Not Found**: Always check entity_registry_snapshot.json for current entities
2. **Area Mismatch**: Verify area assignments match actual home layout
3. **Platform Conflicts**: Consider integration-specific limitations
4. **Mobile Notifications**: Verify device IDs and notification permissions
5. **Actionable Notification Issues**: Check `mobile_app_notification_action` event handlers exist for all notification actions
6. **Platform-Specific Features**: Verify Android (3 actions max) vs iOS (SF Symbols, destructive actions) capabilities
7. **Syntax Changes**: When automations fail, check HA documentation for updated action/trigger syntax
8. **Integration Updates**: Verify configuration still matches current integration requirements

### Debugging Approach
1. Use Home Assistant's automation trace feature
2. Check Home Assistant logs for entity errors
3. Verify entity states in Developer Tools
4. Test changes incrementally
5. **Check HA Documentation**: For new error messages or unexpected behavior, search recent HA release notes and integration docs
6. **Validate Configuration**: Use HA's configuration check tools before committing changes

### Memory Management
- Update memory with successful solutions
- Document common issues and resolutions
- Track entity changes and their impacts
- Maintain troubleshooting notes

## Security & Best Practices

### Sensitive Information
- Use `secrets.yaml` for credentials (not committed to repo)
- Avoid hardcoding personal information in configurations
- Use device-agnostic naming where possible

### Configuration Management
- Git-based version control with develop-ha branch
- Automated sync capabilities via shell commands
- Regular entity registry updates
- Backup strategies for critical configurations

### Testing & Validation
- Test new automations in safe conditions
- Use automation trace for debugging
- Validate entity states before deployment
- Monitor system performance impact

## Repository Maintenance

### Regular Tasks
1. Update `entity_registry_snapshot.json` after device changes
2. Review and clean up `docs/memory.md`
3. Test critical automations monthly
4. Update documentation for major changes
5. **Check HA Release Notes**: Review monthly releases for breaking changes affecting this configuration
6. **Validate Integration Updates**: Test automations after major integration updates
7. **Documentation Sync**: Update local references when HA docs show significant changes to heavily-used integrations

### Memory File Management
The `docs/memory.md` file should contain:
- Current project context and goals
- Recent entity discoveries and changes
- Automation relationships and dependencies
- Troubleshooting notes and solutions
- Configuration decisions and rationale

### Version Control
- Use meaningful commit messages
- Branch strategy: develop-ha for testing, main for stable
- Regular pushes to maintain backup
- Document breaking changes

## Support & Resources

### Home Assistant Community
- Reference existing blueprints and community solutions
- Contribute improvements back to community
- Document unique solutions for future reference

### Integration Documentation
- Always reference official integration documentation
- Understand platform-specific limitations
- Keep up with Home Assistant release notes

### Performance Monitoring
- Monitor automation execution times
- Watch for entity state loops
- Optimize based on system performance
- Regular cleanup of unused entities

Remember: This is a production smart home system. Changes should be tested carefully and documented thoroughly. Always maintain the balance between automation sophistication and system reliability.