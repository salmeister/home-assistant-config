# Copilot Memory - Home Assistant Configuration

**Purpose**: This file serves as persistent memory for GitHub Copilot to maintain context across conversations and development sessions.

**Last Updated**: September 18, 2025  
**Current Branch**: develop-ha  
**Repository**: salmeister/home-assistant-config

## Recent Updates (September 18, 2025)
- ✅ Updated `.copilot/instructions.md` to make memory file reading MANDATORY first step
- ✅ Verified Copilot instructions are properly configured and accessible
- 📋 Instructions now enforce: Memory → Entity Registry → Task execution workflow

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

### Active Projects
- 📝 Document existing automation relationships
- 📝 Create troubleshooting guides for common issues
- 📝 Establish entity change tracking procedures

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
- **Usage**: Reference this document when creating Frigate-based automations, sensors, or controls
- **Maintenance**: Update reference document after major Frigate releases to capture new/changed topics
- **Event Structure**: Detailed JSON payloads for events, reviews, and tracked object updates
- **Camera Controls**: Complete MQTT command set for enabling/disabling detection, recording, notifications
- **⚠️ REMINDER**: Always update `docs/frigate-reference.md` when upgrading Frigate major versions

---

**Note**: This memory file should be updated regularly with new discoveries, completed tasks, and ongoing context. Clear completed items and add new information as the configuration evolves.