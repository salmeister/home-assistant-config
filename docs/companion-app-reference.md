# Home Assistant Companion App Reference

This document serves as a comprehensive reference for the Home Assistant Companion App integration, focusing on actionable notifications, device management, and mobile integration patterns used within this home automation system.

> **⚠️ IMPORTANT**: This reference should be updated when upgrading the companion app or Home Assistant core, as new notification features and device capabilities may be added. Always check the [official companion app documentation](https://companion.home-assistant.io/docs/) after major updates.

## Device Overview

### Household Mobile Devices

Based on current system configuration:

| Device | Platform | Device ID | Primary User | Notes |
|--------|----------|-----------|--------------|-------|
| SALMOB1 | Android | `mobile_app_salmob1` | Andy | Primary Android device |
| SALMOB2 | Android | `mobile_app_salmob2` | Katie | Primary Android device |
| SALMOB3 | iOS | `mobile_app_karlees_iphone_16` | Karlee | **Only iOS device** |
| SALMOB4 | Android | `mobile_app_salmob4` | [User] | Secondary Android device |
| SALMOB5 | Android | `mobile_app_salmob5` | [User] | Secondary Android device |

### Notification Groups

| Group Name | Purpose | Included Devices |
|------------|---------|------------------|
| `all_android_devices` | Android-specific notifications | SALMOB1, SALMOB2, SALMOB4, SALMOB5 |
| `all_apple_devices` | iOS-specific notifications | SALMOB3 |
| `all_mobile_devices` | Universal notifications | All devices |
| `parent_mobile_devices` | Parent-only notifications | SALMOB1, SALMOB2 |

## Actionable Notifications

### Platform Differences

#### Android Capabilities
- **Action Limit**: 3 notification actions maximum
- **Icon Support**: Material Design Icons (not available in actions)
- **Text Input**: Supported via `behavior: textInput` or `action: REPLY`
- **URI Actions**: Requires `action: URI` to use `uri` parameter
- **Deep Links**: Supports `deep-link://` and `app://` schemes
- **Intent Schemes**: Supports intent URIs for complex app interactions

#### iOS Capabilities  
- **Action Limit**: ~10 notification actions (more causes UI scrolling issues)
- **Icon Support**: SF Symbols library with `sfsymbols:` prefix
- **Text Input**: Supported with customizable placeholder and button text
- **URI Actions**: Direct URI support without special action type
- **Authentication**: Optional passcode requirement for sensitive actions
- **Destructive Actions**: Red-colored actions for dangerous operations

### Standard Notification Structure

```yaml
action: notify.mobile_app_<device_id>
data:
  title: "Notification Title"
  message: "Clear, actionable message"
  data:
    # Basic options
    tag: "unique_identifier"           # For notification replacement/clearing
    group: "category_name"             # Group related notifications
    persistent: true                   # Prevent swipe-to-dismiss
    
    # Channel configuration (Android)
    channel: "alert_type"              # Custom notification channel
    importance: high                   # high, low, normal, max, min
    
    # Visual elements
    image: "{{ snapshot_url }}"        # Include images/snapshots
    icon: "mdi:icon-name"             # Notification icon (not for actions)
    
    # Actions array
    actions:
      - action: "ACTION_IDENTIFIER"
        title: "Button Text"
        # Platform-specific options...
```

### Action Configuration

#### Universal Action Options
```yaml
actions:
  - action: "UNIQUE_ACTION_ID"         # Required: Event identifier
    title: "Display Text"             # Required: Button label
    uri: "/lovelace/dashboard"         # Optional: Navigation target
```

#### Android-Specific Options
```yaml
actions:
  - action: "URI"                      # Required for URI actions
    title: "Open App"
    uri: "app://com.package.name"      # App package or deep link
  
  - action: "REPLY"                    # Built-in text input
    title: "Respond"
  
  - action: "CUSTOM_ACTION"
    title: "Text Input"
    behavior: "textInput"              # Custom text input action
```

#### iOS-Specific Options
```yaml
actions:
  - action: "CUSTOM_ACTION"
    title: "Action Title"
    icon: "sfsymbols:bell"             # SF Symbols only
    activationMode: "foreground"       # background (default) or foreground
    authenticationRequired: true       # Require passcode
    destructive: true                  # Red destructive action
    textInputButtonTitle: "Send"       # Text input button
    textInputPlaceholder: "Enter text" # Input placeholder
```

### URI Navigation Patterns

#### Lovelace Views
```yaml
uri: "/lovelace/cameras"               # Main dashboard view
uri: "/lovelace-garage/control"        # Custom dashboard
uri: "entityId:sun.sun"                # Entity more-info dialog
```

#### System Actions
```yaml
uri: "settings://notification_history" # Android notification history
uri: "tel:+15551234567"                # Phone call (iOS)
uri: "https://example.com"             # External URL
```

#### App Integration
```yaml
# Android
uri: "app://com.twitter.android"       # Launch app by package
uri: "deep-link://custom_scheme"       # Custom deep link
uri: "intent://scan/#Intent;scheme=zxing;package=com.google.zxing.client.android;end"

# iOS  
uri: "app://twitter"                   # Launch app by name
uri: "tel:2125551212"                  # System URL schemes
```

## Event Handling

### Notification Action Events

When users tap notification actions, Home Assistant fires the `mobile_app_notification_action` event:

```yaml
# Event structure
{
  "event_type": "mobile_app_notification_action",
  "data": {
    "action": "ACTION_IDENTIFIER",           # The action that was tapped
    "sourceDeviceID": "mobile_app_salmob1",  # Device that triggered the action
    "reply_text": "User response",          # Present for text input actions
    "tag": "notification_tag",              # Original notification tag
    "action_data": {                        # iOS: Custom data sent with notification
      "entity_id": "light.example",
      "custom_key": "custom_value"
    }
  },
  "origin": "REMOTE",
  "time_fired": "2024-12-01T12:00:00.000000+00:00",
  "context": {
    "id": "context_id",
    "user_id": "user_id"
  }
}
```

### Automation Triggers

#### Specific Action Trigger
```yaml
trigger:
  - platform: event
    event_type: mobile_app_notification_action
    event_data:
      action: "SPECIFIC_ACTION"
```

#### Device-Specific Trigger
```yaml
trigger:
  - platform: event
    event_type: mobile_app_notification_action
    event_data:
      sourceDeviceID: "mobile_app_salmob1"
```

#### Catch-All Pattern
```yaml
trigger:
  - platform: event
    event_type: mobile_app_notification_action
# Use conditions to filter specific actions
condition:
  - condition: template
    value_template: "{{ trigger.event.data.action in ['ACTION1', 'ACTION2'] }}"
```

## Current System Implementation Examples

### Garage Door Notifications

The system uses a sophisticated garage door notification pattern:

```yaml
# Enhanced garage notification with AI description
action: notify.mobile_app_salmob1
data:
  title: "🚗 Garage Entry Detected"
  message: >-
    {{ people_text }} entered the garage.
    {% if ai_description != 'AI description not available' %}
    
    🤖 {{ ai_description }}
    {% endif %}
    
    📍 Time: {{ now().strftime('%I:%M %p') }}
  data:
    tag: "{{ session_tag }}"
    group: "garage_security"
    sticky: true
    channel: "garage_alerts"
    importance: high
    image: "{{ snapshot_url }}"
    actions:
      - action: "VIEW_GARAGE_CLIP"
        title: "View"
        icon: "sli:video"              # Note: This may not work on all platforms
      - action: "DISMISS_GARAGE_ALERT"
        title: "Dismiss"
        icon: "sli:check"
```

### Action Handler Pattern
```yaml
# Garage action handler automation
- id: handle_enhanced_garage_actions
  alias: Handle Enhanced Garage Actions
  triggers:
    - trigger: event
      event_type: mobile_app_notification_action
      event_data:
        action: VIEW_GARAGE_CLIP
    - trigger: event
      event_type: mobile_app_notification_action
      event_data:
        action: DISMISS_GARAGE_ALERT
  actions:
    - choose:
        - conditions:
            - condition: template
              value_template: "{{ trigger.event.data.action == 'VIEW_GARAGE_CLIP' }}"
          sequence:
            - action: notify.mobile_app_{{ trigger.event.data.sourceDeviceID.replace('mobile_app_', '') }}
              data:
                title: "🎬 Opening Garage Events"
                message: "Tap to view recent garage events in Frigate"
                data:
                  url: "{{ frigate_events_url }}"
                  clickAction: "{{ frigate_events_url }}"
```

### Notification Blueprint Integration

The system includes a custom blueprint for Android actionable notifications at:
`blueprints/automation/salmeister/actionable_notification_on_boolean.yaml`

This blueprint provides:
- Device selector for mobile app devices
- Boolean entity trigger configuration
- Up to 3 customizable actions with URI support
- Dynamic action generation based on configuration

## Advanced Features

### Notification Clearing

```yaml
# Clear specific notification
action: notify.mobile_app_device
data:
  message: "clear_notification"
  data:
    tag: "notification_tag_to_clear"

# Clear all notifications
action: notify.mobile_app_device
data:
  message: "clear_notification"
```

### Critical Notifications (iOS)
```yaml
data:
  data:
    push:
      sound:
        critical: 1
        name: "default"
        volume: 1.0
```

### Notification Channels (Android)
```yaml
data:
  data:
    channel: "Security Alerts"
    importance: max
    vibrationPattern: "100, 1000, 100, 1000"
    ledColor: "red"
```

### Notification Categories (iOS Legacy)
> **Note**: Categories are deprecated in favor of inline actions. Convert existing category-based notifications to use the `actions` array.

## Best Practices for This System

### 1. Device-Aware Notifications

Given the 4 Android + 1 iOS device setup:

```yaml
# Android-optimized notifications (4 devices)
- action: notify.all_android_devices
  data:
    title: "Android Notification"
    data:
      actions:  # Limit to 3 actions
        - action: "ACTION1"
          title: "Primary"
        - action: "ACTION2" 
          title: "Secondary"
        - action: "ACTION3"
          title: "Dismiss"

# iOS-specific notification (SALMOB3 only)
- action: notify.mobile_app_karlees_iphone_16
  data:
    title: "iOS Notification" 
    data:
      actions:  # Can use up to ~10 actions
        - action: "ACTION1"
          title: "Primary Action"
          icon: "sfsymbols:checkmark"
          destructive: false
        # ... more actions possible
```

### 2. Unique Action Identifiers

Use context-aware action IDs to prevent cross-automation conflicts:

```yaml
variables:
  action_id: "{{ 'GARAGE_CLOSE_' ~ context.id }}"
  
actions:
  - action: "{{ action_id }}"
    title: "Close Garage"
```

### 3. Parent-Focused Notifications

Leverage the `parent_mobile_devices` group for security and maintenance alerts:

```yaml
action: notify.parent_mobile_devices
data:
  title: "Security Alert"
  message: "Garage door opened while armed"
  data:
    importance: high
    persistent: true
```

### 4. Script-Based Response Handling

Use scripts for complex action responses:

```yaml
# In automation
- wait_for_trigger:
    platform: event
    event_type: mobile_app_notification_action
    timeout: 300  # 5-minute timeout
- choose:
    - conditions: "{{ wait.trigger.event.data.action == 'COMPLEX_ACTION' }}"
      sequence:
        - action: script.handle_complex_notification_action
          data:
            device_id: "{{ wait.trigger.event.data.sourceDeviceID }}"
            action_data: "{{ wait.trigger.event.data }}"
```

### 5. Notification Lifecycle Management

```yaml
# Send notification with timeout and cleanup
- action: notify.mobile_app_device
  data:
    title: "Temporary Alert"
    data:
      tag: "temp_alert"
      timeout: 30  # Auto-dismiss after 30 seconds

# Manual cleanup after action
- action: notify.mobile_app_device
  data:
    message: "clear_notification"
    data:
      tag: "temp_alert"
```

## Android vs iOS Compatibility Matrix

| Feature | Android | iOS | Notes |
|---------|---------|-----|--------|
| Basic Actions | ✅ (3 max) | ✅ (10 max) | Android more limited |
| Text Input | ✅ | ✅ | Different implementation |
| URI Navigation | ✅ (URI action) | ✅ (direct) | Android requires special action |
| Custom Icons | ❌ | ✅ (SF Symbols) | Android actions don't support icons |
| Destructive Actions | ❌ | ✅ | iOS visual distinction |
| Authentication | ❌ | ✅ | iOS passcode requirement |
| Deep Links | ✅ | ✅ | Different schemes |
| Notification Channels | ✅ | ❌ | Android-specific |
| Critical Notifications | ❌ | ✅ | iOS-specific |

## Troubleshooting Common Issues

### Actions Not Appearing
1. Verify companion app version supports actionable notifications
2. Check notification permissions in device settings
3. Ensure notification isn't being delivered as silent/background

### Event Not Firing
1. Verify `mobile_app` integration is enabled in Home Assistant
2. Check that device ID matches exactly in trigger
3. Look for duplicate action identifiers causing conflicts

### iOS-Specific Issues
1. Ensure SF Symbols icons exist in iOS version
2. Check that `ios:` integration is configured (if using legacy categories)
3. Verify critical notification permissions for important alerts

### Android-Specific Issues
1. Confirm Google Play Services is available and updated
2. Check notification channel settings haven't disabled the channel
3. Verify URI actions use `action: URI` format

## Integration with Other Systems

### Frigate Camera Integration
```yaml
# Use Frigate snapshot URLs in notifications
image: "/api/frigate/notifications/{{ event_id }}/snapshot.jpg"
actions:
  - action: "VIEW_CLIP"
    title: "View Video"
    uri: "/api/frigate/notifications/{{ event_id }}/clip.mp4"
```

### Google Assistant SDK Integration
```yaml
# Parallel notification to mobile and voice hub
parallel:
  - action: notify.mobile_app_salmob1
    data:
      title: "Mobile Alert"
      data:
        actions:
          - action: "ACKNOWLEDGE"
            title: "OK"
  - action: notify.google_assistant_sdk
    data:
      message: "Voice announcement"
      target: ["kitchen"]
```

## Security Considerations

### Sensitive Actions
- Use iOS authentication requirements for destructive actions
- Implement confirmation dialogs for irreversible operations
- Consider notification clearing for temporary sensitive information

### Device Trust
- Validate device IDs in action handlers
- Use notification tags to prevent unauthorized clearing
- Implement timeouts for security-related notifications

## Maintenance Tasks

### Regular Updates
1. **Companion App Updates**: Check for new notification features and capabilities
2. **Device Registration**: Verify all household devices are properly registered
3. **Icon Compatibility**: Update SF Symbols icons when iOS updates
4. **Channel Management**: Review Android notification channels for relevance

### Testing Procedures
1. **Cross-Platform Testing**: Test notifications on both Android and iOS devices
2. **Action Response**: Verify all notification actions trigger correct automations
3. **Timeout Handling**: Ensure notifications timeout appropriately
4. **Performance**: Monitor notification delivery speed and reliability

### Documentation Updates
- Update device list when household devices change
- Document new notification patterns and successful implementations
- Record platform-specific workarounds and solutions
- Maintain compatibility matrix for new features

## Migration Notes

### From Legacy Categories (iOS)
If migrating from iOS category-based notifications:

1. Replace `push.category` with inline `actions` array
2. Update event triggers from `ios.notification_action_fired` to `mobile_app_notification_action`
3. Modify event data access patterns (`actionName` → `action`)

### Platform-Specific Migration
When adding new iOS device (beyond SALMOB3):
- Add to `all_apple_devices` notification group
- Update iOS-specific automations to target new device
- Configure SF Symbols icons for iOS-specific features

When adding new Android devices:
- Add to `all_android_devices` notification group
- Ensure 3-action limit compliance
- Test URI action patterns

---

*Last updated: December 2024 - Based on Home Assistant Companion App documentation and system implementation*
*Remember to update this reference when upgrading the companion app or adding new household devices!*