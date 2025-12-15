# Copilot Memory - Home Assistant Configuration

**Purpose**: This file serves as persistent memory for GitHub Copilot to maintain context across conversations and development sessions.

**Last Updated**: October 23, 2025  
**Current Branch**: develop-ha  
**Repository**: salmeister/home-assistant-config

## Recent Updates (October 24, 2025)
- ✅ **MAJOR IMPROVEMENT**: Zone-based garage door notification system implemented
- ✅ Replaced arbitrary 3-second delay with intelligent Interior Garage zone occupancy detection
- ✅ Added 3-minute wait period for real-world scenarios (parking, gathering items, walking to garage)
- ✅ Implemented fallback notifications when door opens but no person detected
- ✅ All notifications now guaranteed to include images (Frigate snapshots or live camera)
- ✅ Multi-person face recognition with proper name aggregation ("Andy and Katie")
- ✅ Single notification per event using `mode: single`

## Recent Updates (October 23, 2025)
- ✅ Enhanced Garage Door Security Notification automation with comprehensive improvements
- ✅ Added multi-person detection support with face recognition aggregation
- ✅ Implemented session-based notification tagging to prevent duplicates
- ✅ Improved snapshot selection logic for best quality images
- ✅ Added consistent video clip linking in all notification paths
- 📋 Notification now uses unique event-based tags for progressive enrichment

## Security & privacy guardrails (public repo)

This repository is public. Copilot and contributors must never add or suggest content that exposes sensitive information. Always default to safe placeholders and references to `!secret` keys.

- Never commit or suggest: passwords, API keys/tokens, OAuth client secrets, webhook URLs, SSH private keys, Wi‑Fi PSKs, bearer tokens, service account files, license keys, device serials/MACs/IMEI/ICCID, or private service URLs with embedded credentials.
- Location & identity privacy: do not include exact home address, latitude/longitude, geofence coordinates, detailed floorplans, live presence schedules, phone numbers, emails, or children’s names. Use area names (e.g., Kitchen, Garage) instead of precise coordinates or addresses.
- Home Assistant specifics to keep out of the repo:
	- Contents of `secrets.yaml` and any credentials. Always use `!secret` in YAML.
	- `homeassistant:` `latitude`, `longitude`, and `elevation` values (store as secrets).
	- Webhook IDs/URLs, cloud hooks, RTSP/HTTP stream URLs with creds, Google Assistant and other integration credentials.
	- Person/device tracker identifiers that reveal real names or precise locations; prefer pseudonyms or generic device names.
- Copilot behavior requirements:
	- Use placeholders like "YOUR_VALUE_HERE" or "<REDACTED>" in examples. Never fabricate or hard‑code secrets.
	- When a change requires credentials, generate `!secret` references and include instructions to put real values in `secrets.yaml` (which is already git‑ignored).
	- Proactively flag and refuse to store sensitive values in code, docs, issues, or commit messages. Offer a redacted version and guidance instead.
- Safe patterns/examples:

	```yaml
	# Use secrets for credentials and sensitive coordinates
	mqtt:
		broker: !secret mqtt_broker
		username: !secret mqtt_user
		password: !secret mqtt_password

	homeassistant:
		latitude: !secret ha_latitude
		longitude: !secret ha_longitude
		elevation: !secret ha_elevation

	notify:
		- platform: html5
			vapid_pub_key: !secret vapid_pub_key
			vapid_prv_key: !secret vapid_prv_key
	```

- Redaction guidance: If logs, screenshots, or JSON (e.g., entity snapshots) are shared, redact unique IDs, serials, tokens, and precise coordinates before committing.
- Quick pre‑commit self‑check:
	- Ensure all credentials and coordinates use `!secret`.
	- Grep mentally for risky terms: "password", "token", "api_key", "secret", "webhook", "bearer", "authorization", "latitude", "longitude".
	- Verify `entity_registry_snapshot.json` does not expose device serials, tokens, or sensitive identifiers when updated.
- Optional protections to consider (not required): local secret scanners (e.g., `detect-secrets`, `git-secrets`) and enabling GitHub Secret Scanning/Push Protection.

## Current Context

### Repository State
- **Entity Registry Last Checked**: September 3, 2025
- **Total Entities**: ~5000+ entities in entity_registry_snapshot.json
- **Active Automations**: 60+ automations in automations.yaml
- **Key Integrations**: Frigate, Z-Wave, Rachio, Google Assistant

### Recent Discoveries
- Repository includes comprehensive Copilot instructions system
- Memory system established in docs/memory.md
- Entity registry contains detailed area mappings for all devices
- Advanced garage door security system with Frigate integration
- Sophisticated notification system with actionable mobile alerts

## Entity Inventory Summary

### Key Areas Identified
Based on entity_registry_snapshot.json review:

**Kitchen**
- `input_boolean.unload_dishwasher` - Dishwasher reminder system
- Fridge water leak sensors and monitoring
- Crock-pot automation entities

**Garage** 
- Frigate camera integration for person detection
- Garage door security automations
- Back entry light integration

**Basement**
- Multiple water detection sensors
- Temperature monitoring systems
- Sump pump level monitoring
- Water softener alerts

**Master Bedroom**
- Night light automation
- Bath lighting controls

**Laundry Room**
- Water detection sensors
- Temperature monitoring

**Porch**
- Dog feeding automation systems

### Critical Entities
- Rachio sprinkler system with 7 zones
- Z-Wave lighting controls throughout home
- Multiple Frigate camera integrations
- Comprehensive water leak detection network
- Advanced security system with multiple armed states

## Automation Relationships

### Garage Door System
- Primary security feature with multiple automations
- Integrates Frigate person detection
- Mobile notifications with video clips
- Google Assistant voice control
- Back entry light status indicators

### Lighting System
- Zone-based control with area assignments
- Dawn/Dusk scene automation
- Always-on switch management for smart bulbs
- Motion-based activation patterns

### Security & Monitoring
- Tiered security modes (external armed, full armed, home)
- Water detection network across multiple areas
- Temperature monitoring with low temp alerts
- Device health monitoring with battery alerts

## Development Patterns

### Notification Standards
- Mobile app integration with rich media
- Actionable notifications with embedded controls
- Device-specific targeting based on entity registry
- Image and video clip integration

### Area-Based Logic
- Area assignments from entity registry drive automation logic
- Location-specific behaviors for different rooms
- Consistent naming patterns across similar areas

### Integration Approaches
- Frigate: Camera-based with zone detection
- Z-Wave: Mesh network with always-on switches
- Rachio: Irrigation with weather integration
- Google Assistant: Voice control with hub targeting

## Configuration Decisions

### Repository Structure
- Main configuration files in root directory
- Blueprints organized by author and type
- Python scripts for custom logic
- Documentation in docs/ directory

### Entity Management
- entity_registry_snapshot.json as authoritative source
- Regular updates to maintain accuracy
- Area assignments drive automation logic
- Platform-specific considerations for different integrations

### Security Approach
- Git-based configuration management
- secrets.yaml for sensitive information
- Automated sync with safety toggles
- Backup strategies for critical configurations

## Current Tasks & Context

### Completed
- ✅ Created Copilot instructions system
- ✅ Established memory management framework
- ✅ Reviewed entity registry structure
- ✅ Documented key automation patterns
- ✅ Added washing machine dryer reminder automation (September 24, 2025)

### Active Projects
- 📝 Document existing automation relationships
- 📝 Create troubleshooting guides for common issues
- 📝 Establish entity change tracking procedures

### Recent Automation Additions (September 24, 2025)
- **Washing Machine Dryer Reminder**: New automation `washing_machine_dryer_reminder` that notifies Andy (SALMOB1) when washing machine completes but dryer door hasn't opened after 10 minutes
  - **Trigger**: `sensor.washer_washer_job_state` changes to "complete"
  - **Conditions**: 10-minute delay, dryer door still closed (`binary_sensor.dryer_door_window_door_is_open` = 'off'), Andy notifications enabled
  - **Action**: Mobile notification with message "Washing machine is done, dryer time!"
  - **Pattern**: Follows existing notification patterns with `input_boolean.notify_fpm_andy` condition check

### Recent Automation Updates (October 23, 2025)
- **Enhanced Garage Door Security Notification - Comprehensive Upgrade**: Major improvements to ID `48f92e3c7d1a4b8e9f5a2c8d9e7f6a1b`
  - **Problem**: Notifications inconsistent across detection paths, potential duplicates, unclear person identification
  - **Solution**: Complete overhaul with session-based tracking, improved person detection, and consistent media handling
  - **Key Changes**:
    - **Session Tagging**: Unique event-based notification tags (`garage_event_<id>`) prevent duplicate notifications
    - **Multi-Person Support**: Added face recognition trigger and logic to track multiple people in single event
    - **Snapshot Selection**: Prioritized best quality snapshots (Frigate detection > event > face recognition > live camera)
    - **Video Links**: Consistent video clip URLs in all notification paths using Frigate notification API
    - **Progressive Enrichment**: GenAI descriptions update existing notifications using same tag
    - **Face Recognition**: Enhanced wait logic and recent face detection (2-minute window)
    - **Notification Actions**: 3 Android-compatible actions (View Clip, View Snapshot, Dismiss)
    - **Message Formatting**: Cleaner people_text with proper grammar, improved emoji usage (🚗 vs 🚶‍➡️)
  - **Triggers**: Door-open, frigate-event, frigate-genai-update, face-recognition (new)
  - **Media Handling**: All paths now include snapshot_url, video_url with proper fallbacks
  - **Tag Strategy**: Uses frigate_event_id > frigate_detection_id > door timestamp for consistent updates
  - **Result**: Single notification per event, progressive enrichment, recognized person names, quality snapshots, video links
  - **Mode**: Restart mode allows newer detections to override pending ones

### Recent Automation Updates (September 25, 2025)
- **Frigate Person Name Display Fix**: Updated person_name templates in garage detection automations
  - **Problem**: Notifications showing "None" or "Unknown" instead of user-friendly names
  - **Solution**: Enhanced Jinja2 templates to handle all variations of None/Unknown values (case-insensitive)
  - **Changes**: 
    - Added `| string | lower` conversion for robust string comparison
    - Changed fallback from "A Person" to "Person" for cleaner notifications
    - Updated all related conditional checks for consistent behavior
  - **Templates Updated**: Both GenAI and standard garage person detection automations
  - **Result**: Notifications will now show "Person" instead of "None", "Unknown", or other placeholder values

### Future Considerations
- Enhanced mobile notification templates
- Additional Frigate camera integrations
- Energy monitoring expansion
- Voice control enhancements

## Troubleshooting Notes

### Common Issues
- Entity ID changes require automation updates
- Area assignments affect automation targeting
- Z-Wave mesh topology impacts reliability
- Mobile app device IDs need verification

### Solutions Applied
- Regular entity registry reviews
- Consistent naming patterns
- Device-agnostic configurations where possible
- Comprehensive testing procedures

## Knowledge Base

### Entity Registry Insights
- Contains 5000+ entities across multiple platforms
- Area assignments provide automation context
- Platform information guides integration approach
- Capabilities define automation possibilities

### Automation Patterns
- Security-first approach with multiple validation layers
- Area-based logic for location-specific behaviors
- Rich notification patterns with media integration
- Voice control integration for key functions

### Integration Specifics
- Frigate requires camera name matching
- Z-Wave benefits from always-on switch patterns
- Rachio integration provides weather-aware irrigation
- Google Assistant needs device-specific targeting

### Frigate Integration Reference
- **Reference Document**: `docs/frigate-reference.md` contains comprehensive MQTT topic documentation and Home Assistant integration details
- **Available Topics**: Events, stats, camera controls, object counts, PTZ commands, notifications
- **Home Assistant API**: Notification endpoints, entity types, media browser integration
- **GenAI Integration**: Complete GenAI capabilities section with send_triggers, intent analysis, and automation examples
- **Official Notification Guidance**: Integration of Frigate's official Home Assistant notification patterns and best practices
- **Platform-Specific Examples**: iOS/Android optimized notification templates with proper media handling
- **Blueprint Reference**: Link to official Frigate notification blueprint for starting point
- **Reviews vs Events**: Clear guidance on when to use `frigate/reviews` vs `frigate/events` topics
- **Usage**: Reference this document when creating Frigate-based automations, sensors, or controls
- **Maintenance**: Update reference document after major Frigate releases to capture new/changed topics
- **Event Structure**: Detailed JSON payloads for events, reviews, and tracked object updates
- **Camera Controls**: Complete MQTT command set for enabling/disabling detection, recording, notifications
- **⚠️ REMINDER**: Always update `docs/frigate-reference.md` when upgrading Frigate major versions
- **📅 UPDATED**: September 24, 2025 - Added GenAI integration section and official HA notification guidance

---

**Note**: This memory file should be updated regularly with new discoveries, completed tasks, and ongoing context. Clear completed items and add new information as the configuration evolves.