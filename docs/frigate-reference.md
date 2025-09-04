# Frigate Integration Reference

This document serves as a comprehensive reference for Frigate integration with Home Assistant, including MQTT topics, notification APIs, and entity management. This reference should be consulted when setting up automations, sensors, or other Frigate integrations.

> **⚠️ IMPORTANT**: This reference should be updated whenever there is a major Frigate release, as new MQTT topics may be added or existing ones may be modified. Always check the [official Frigate MQTT documentation](https://docs.frigate.video/integrations/mqtt/) after upgrading.

## General Frigate Topics

### System Control Topics

| Topic | Type | Description | Values |
|-------|------|-------------|---------|
| `frigate/available` | Status | Frigate availability for Home Assistant | `online`, `offline` |
| `frigate/restart` | Command | Causes Frigate to exit (for Docker restart) | Any message |

### Event and Data Topics

| Topic | Type | Description | Payload |
|-------|------|-------------|---------|
| `frigate/events` | Event | Object tracking events with detailed metadata | JSON object with `before`/`after` states |
| `frigate/tracked_object_update` | Event | Updates to tracked object metadata | JSON with type-specific data |
| `frigate/reviews` | Event | Review item changes (detection/alert severity) | JSON with review details |
| `frigate/stats` | Data | System statistics (same as `/api/stats`) | JSON statistics object |
| `frigate/camera_activity` | Data | Camera status and activity information | JSON camera activity data |

### Global Notification Control

| Topic | Type | Description | Values |
|-------|------|-------------|---------|
| `frigate/notifications/set` | Command | Turn notifications on/off globally | `ON`, `OFF` |
| `frigate/notifications/state` | Status | Current global notification state | `ON`, `OFF` |

## Camera-Specific Topics

### Object Detection Counts

| Topic Pattern | Description | Values |
|---------------|-------------|---------|
| `frigate/<camera_name>/<object_name>` | Total object count for camera | Integer count |
| `frigate/<camera_name>/<object_name>/active` | Active object count for camera | Integer count |
| `frigate/<camera_name>/all` | Total count of all objects | Integer count |
| `frigate/<camera_name>/all/active` | Active count of all objects | Integer count |

### Zone-Based Object Counts

| Topic Pattern | Description | Values |
|---------------|-------------|---------|
| `frigate/<zone_name>/<object_name>` | Object count in specific zone | Integer count |
| `frigate/<zone_name>/<object_name>/active` | Active object count in zone | Integer count |
| `frigate/<zone_name>/all` | Total objects in zone | Integer count |
| `frigate/<zone_name>/all/active` | Active objects in zone | Integer count |

### Media Topics

| Topic Pattern | Description | Payload |
|---------------|-------------|---------|
| `frigate/<camera_name>/<object_name>/snapshot` | JPEG snapshot of detected object | Binary JPEG data |

### Audio Detection Topics

| Topic Pattern | Description | Values |
|---------------|-------------|---------|
| `frigate/<camera_name>/audio/<audio_type>` | Audio detection status | `ON`, `OFF` |
| `frigate/<camera_name>/audio/dBFS` | Audio level in dBFS | Decimal number |
| `frigate/<camera_name>/audio/rms` | Audio RMS value | Decimal number |

### Camera Control Topics

#### General Camera Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/enabled/set` | Command | Enable/disable camera processing | `ON`, `OFF` |
| `frigate/<camera_name>/enabled/state` | Status | Camera processing state | `ON`, `OFF` |

#### Detection Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/detect/set` | Command | Enable/disable object detection | `ON`, `OFF` |
| `frigate/<camera_name>/detect/state` | Status | Object detection state | `ON`, `OFF` |
| `frigate/<camera_name>/audio/set` | Command | Enable/disable audio detection | `ON`, `OFF` |
| `frigate/<camera_name>/audio/state` | Status | Audio detection state | `ON`, `OFF` |

#### Recording Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/recordings/set` | Command | Enable/disable recordings | `ON`, `OFF` |
| `frigate/<camera_name>/recordings/state` | Status | Recording state | `ON`, `OFF` |
| `frigate/<camera_name>/snapshots/set` | Command | Enable/disable snapshots | `ON`, `OFF` |
| `frigate/<camera_name>/snapshots/state` | Status | Snapshot state | `ON`, `OFF` |

#### Motion Detection Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/motion/set` | Command | Enable/disable motion detection | `ON`, `OFF` |
| `frigate/<camera_name>/motion` | Status | Current motion detection status | `ON`, `OFF` |
| `frigate/<camera_name>/motion/state` | Status | Motion detection state | `ON`, `OFF` |
| `frigate/<camera_name>/motion_threshold/set` | Command | Adjust motion threshold | Integer value |
| `frigate/<camera_name>/motion_threshold/state` | Status | Current motion threshold | Integer value |
| `frigate/<camera_name>/motion_contour_area/set` | Command | Adjust motion contour area | Integer value |
| `frigate/<camera_name>/motion_contour_area/state` | Status | Current motion contour area | Integer value |

#### Image Processing Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/improve_contrast/set` | Command | Enable/disable contrast improvement | `ON`, `OFF` |
| `frigate/<camera_name>/improve_contrast/state` | Status | Contrast improvement state | `ON`, `OFF` |

### PTZ (Pan-Tilt-Zoom) Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/ptz` | Command | Send PTZ commands | See PTZ commands below |
| `frigate/<camera_name>/ptz_autotracker/set` | Command | Enable/disable PTZ autotracker | `ON`, `OFF` |
| `frigate/<camera_name>/ptz_autotracker/state` | Status | PTZ autotracker state | `ON`, `OFF` |
| `frigate/<camera_name>/ptz_autotracker/active` | Status | PTZ autotracker actively tracking | `ON`, `OFF` |

#### PTZ Commands

| Command | Description |
|---------|-------------|
| `preset_<preset_name>` | Move to named preset |
| `MOVE_UP` | Continuously move up |
| `MOVE_DOWN` | Continuously move down |
| `MOVE_LEFT` | Continuously move left |
| `MOVE_RIGHT` | Continuously move right |
| `ZOOM_IN` | Continuously zoom in |
| `ZOOM_OUT` | Continuously zoom out |
| `STOP` | Stop movement |

### Review and Alert Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/review_status` | Status | Current camera activity status | `NONE`, `DETECTION`, `ALERT` |
| `frigate/<camera_name>/review_alerts/set` | Command | Enable/disable review alerts | `ON`, `OFF` |
| `frigate/<camera_name>/review_alerts/state` | Status | Review alerts state | `ON`, `OFF` |
| `frigate/<camera_name>/review_detections/set` | Command | Enable/disable review detections | `ON`, `OFF` |
| `frigate/<camera_name>/review_detections/state` | Status | Review detections state | `ON`, `OFF` |

### Birdseye Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/birdseye/set` | Command | Enable/disable camera in Birdseye | `ON`, `OFF` |
| `frigate/<camera_name>/birdseye/state` | Status | Birdseye inclusion state | `ON`, `OFF` |
| `frigate/<camera_name>/birdseye_mode/set` | Command | Set Birdseye mode | `CONTINUOUS`, `MOTION`, `OBJECTS` |
| `frigate/<camera_name>/birdseye_mode/state` | Status | Current Birdseye mode | `CONTINUOUS`, `MOTION`, `OBJECTS` |

#### Birdseye Modes

| Mode | Description |
|------|-------------|
| `CONTINUOUS` | Always included in Birdseye view |
| `MOTION` | Show when motion detected within last 30 seconds |
| `OBJECTS` | Show when active object tracked within last 30 seconds |

### Camera Notification Controls

| Topic Pattern | Type | Description | Values |
|---------------|------|-------------|---------|
| `frigate/<camera_name>/notifications/set` | Command | Enable/disable camera notifications | `ON`, `OFF` |
| `frigate/<camera_name>/notifications/state` | Status | Camera notification state | `ON`, `OFF` |
| `frigate/<camera_name>/notifications/suspend` | Command | Suspend notifications for X minutes | Integer (minutes) |
| `frigate/<camera_name>/notifications/suspended` | Status | Timestamp when suspension ends | UNIX timestamp or 0 |

## Event Data Structures

### Events Topic Payload

The `frigate/events` topic publishes detailed JSON objects with the following structure:

```json
{
  "type": "update",  // "new", "update", "end"
  "before": {
    "id": "1607123955.475377-mxklsc",
    "camera": "front_door",
    "frame_time": 1607123961.837752,
    "snapshot": { /* snapshot data */ },
    "label": "person",
    "sub_label": ["John Smith", 0.79],
    "top_score": 0.958984375,
    "false_positive": false,
    "start_time": 1607123955.475377,
    "end_time": null,
    "score": 0.7890625,
    "box": [424, 500, 536, 712],
    "area": 23744,
    "ratio": 2.113207,
    "region": [264, 450, 667, 853],
    "current_zones": ["driveway"],
    "entered_zones": ["yard", "driveway"],
    "has_snapshot": false,
    "has_clip": false,
    "active": true,
    "stationary": false,
    "motionless_count": 0,
    "position_changes": 2,
    "attributes": { "face": 0.64 },
    "current_attributes": [],
    "current_estimated_speed": 0.71,
    "velocity_angle": 180,
    "recognized_license_plate": "ABC12345",
    "recognized_license_plate_score": 0.933451
  },
  "after": { /* updated object data */ }
}
```

### Tracked Object Update Payload

The `frigate/tracked_object_update` topic publishes updates for specific features:

#### Generative AI Description
```json
{
  "type": "description",
  "id": "1607123955.475377-mxklsc",
  "description": "The car is a red sedan moving away from the camera."
}
```

#### Face Recognition
```json
{
  "type": "face",
  "id": "1607123955.475377-mxklsc",
  "name": "John",
  "score": 0.95,
  "camera": "front_door_cam",
  "timestamp": 1607123958.748393
}
```

#### License Plate Recognition
```json
{
  "type": "lpr",
  "id": "1607123955.475377-mxklsc",
  "name": "John's Car",
  "plate": "123ABC",
  "score": 0.95,
  "camera": "driveway_cam",
  "timestamp": 1607123958.748393
}
```

### Reviews Topic Payload

The `frigate/reviews` topic publishes review activity:

```json
{
  "type": "update",  // "new", "update", "end"
  "before": {
    "id": "1718987129.308396-fqk5ka",
    "camera": "front_cam",
    "start_time": 1718987129.308396,
    "end_time": null,
    "severity": "detection",
    "thumb_path": "/media/frigate/clips/review/thumb-front_cam-1718987129.308396-fqk5ka.webp",
    "data": {
      "detections": ["1718987128.947436-g92ztx", "1718987148.879516-d7oq7r"],
      "objects": ["person", "car"],
      "sub_labels": [],
      "zones": [],
      "audio": []
    }
  },
  "after": { /* updated review data */ }
}
```

## Common Object Types

Frigate can detect various object types. Common ones include:
- `person`
- `car`
- `truck`
- `bus`
- `motorcycle`
- `bicycle`
- `dog`
- `cat`
- `bird`

## Common Audio Types

When audio detection is enabled, common audio types include:
- `bark`
- `speech`
- `crying`
- `breaking_glass`
- `car_horn`

## Integration Tips

### Home Assistant Sensors

Use object count topics to create sensors:
```yaml
sensor:
  - platform: mqtt
    name: "Front Door People Count"
    state_topic: "frigate/front_door/person"
    icon: mdi:account
```

### Automation Triggers

Use event topics for advanced automations:
```yaml
automation:
  - trigger:
      platform: mqtt
      topic: frigate/events
    condition:
      condition: template
      value_template: "{{ trigger.payload_json.after.label == 'person' and 'front_yard' in trigger.payload_json.after.current_zones }}"
```

### Camera Controls

Control camera features via MQTT:
```yaml
script:
  disable_front_door_detection:
    sequence:
      - service: mqtt.publish
        data:
          topic: "frigate/front_door/detect/set"
          payload: "OFF"
```

## Home Assistant Notification API

Frigate provides public API endpoints through the Home Assistant integration for notifications without exposing Frigate directly to the web.

### API Endpoints

| Endpoint | Description | Usage |
|----------|-------------|--------|
| `/api/frigate/notifications/<event-id>/thumbnail.jpg` | Load thumbnail for tracked object | Mobile notifications, cards |
| `/api/frigate/notifications/<event-id>/snapshot.jpg` | Load snapshot for tracked object | High-quality images |
| `/api/frigate/notifications/<event-id>/clip.mp4` | Video clip (Android devices) | Android notifications |
| `/api/frigate/notifications/<event-id>/master.m3u8` | Video clip (iOS devices) | iOS notifications |
| `/api/frigate/notifications/<event-id>/event_preview.gif` | Preview GIF for tracked object | Quick previews |
| `/api/frigate/notifications/<review-id>/review_preview.gif` | Preview GIF for review item | Review notifications |

### Multiple Instance Support

When using multiple Frigate instances, include the MQTT `client_id` in URLs:

| Endpoint Pattern | Description |
|------------------|-------------|
| `/api/frigate/<client-id>/notifications/<event-id>/thumbnail.jpg` | Multi-instance thumbnail |
| `/api/frigate/<client-id>/clips/front_door-1624599978.427826-976jaa.mp4` | Multi-instance clip |

> **Note**: When only one Frigate instance is configured, the `client-id` parameter can be omitted.

### Notification Examples

#### Mobile App Notification with Image
```yaml
automation:
  - trigger:
      platform: mqtt
      topic: frigate/events
    action:
      - service: notify.mobile_app_your_phone
        data:
          title: "Person Detected"
          message: "Someone is at the front door"
          data:
            image: "https://your-ha-url/api/frigate/notifications/{{ trigger.payload_json.after.id }}/thumbnail.jpg"
            clickAction: "https://your-ha-url/api/frigate/notifications/{{ trigger.payload_json.after.id }}/clip.mp4"
```

#### Persistent Notification with Snapshot
```yaml
automation:
  - trigger:
      platform: mqtt
      topic: frigate/events
    action:
      - service: persistent_notification.create
        data:
          title: "Security Alert"
          message: "Motion detected in {{ trigger.payload_json.after.camera }}"
          notification_id: "frigate_{{ trigger.payload_json.after.id }}"
```

#### Actionable Notification with Video
```yaml
automation:
  - trigger:
      platform: mqtt
      topic: frigate/events
    action:
      - service: notify.mobile_app_your_phone
        data:
          title: "Person at Door"
          message: "View video?"
          data:
            actions:
              - action: "VIEW_CLIP"
                title: "View Video"
                uri: "https://your-ha-url/api/frigate/notifications/{{ trigger.payload_json.after.id }}/clip.mp4"
              - action: "VIEW_LIVE"
                title: "View Live"
                uri: "app://frigate"
```

## Integration Entities

The Frigate Home Assistant integration provides these entity types:

| Entity Type | Description | Examples |
|-------------|-------------|----------|
| `camera` | Live camera stream (requires RTSP) | `camera.front_door` |
| `image` | Latest detected object image | `image.front_door_person` |
| `sensor` | Object counts, performance stats | `sensor.front_door_person_count` |
| `switch` | Toggle detection, recordings, snapshots | `switch.front_door_detect` |
| `binary_sensor` | Motion detection per camera/zone/object | `binary_sensor.front_door_motion` |

### Entity Examples

#### Object Count Sensors
- `sensor.front_door_person_count` - Current person count
- `sensor.front_door_all_count` - All objects count
- `sensor.yard_zone_person_count` - Person count in yard zone

#### Control Switches
- `switch.front_door_detect` - Enable/disable object detection
- `switch.front_door_recordings` - Enable/disable recordings
- `switch.front_door_snapshots` - Enable/disable snapshots

#### Motion Binary Sensors
- `binary_sensor.front_door_motion` - Camera motion detection
- `binary_sensor.front_door_person_occupancy` - Person presence
- `binary_sensor.yard_zone_person_occupancy` - Person in yard zone

## Media Browser Integration

Frigate provides comprehensive media browsing through Home Assistant:

- **Recordings**: Browse by month, day, camera, time
- **Snapshots**: Browse saved snapshots with thumbnails
- **Tracked Objects**: Browse recordings of detected objects
- **Clips**: Access saved video clips

Access via: **Home Assistant → Media Browser → Frigate**

## Advanced Configuration Tips

### RTSP Stream Template
For custom RTSP configurations (reverse proxies, custom ports):
```yaml
# In integration options
rtsp_url_template: "rtsp://<custom_host>:2000/{{ name|lower }}"
```

### Multiple Instance Setup
Configure different `topic_prefix` and `client_id` for each Frigate instance:
```yaml
# Frigate instance 1
mqtt:
  topic_prefix: frigate_house
  client_id: frigate_house_001

# Frigate instance 2  
mqtt:
  topic_prefix: frigate_garage
  client_id: frigate_garage_001
```

### Casting Support
For clips to be castable to media devices:
- Audio must be enabled in recordings
- Use `.mp4` format for Android devices
- Use `.m3u8` format for iOS devices

## Maintenance Reminders

- **Update Check**: Verify this reference after each major Frigate release
- **Topic Validation**: Test MQTT topics after Frigate upgrades
- **API Endpoints**: Verify notification API URLs after integration updates
- **Entity Changes**: Check for new entity types or naming changes
- **Documentation**: Check [official docs](https://docs.frigate.video/integrations/mqtt/) for new features
- **Breaking Changes**: Review Frigate release notes for MQTT topic changes

---

*Last updated: September 2025 - Based on Frigate documentation*
*Remember to update this reference when upgrading Frigate major versions!*