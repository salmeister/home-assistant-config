# Function to log messages to the custom debug sensor
def log_message(message):
    entity_id = 'sensor.debug_log'
    current_log = hass.states.get(entity_id)

    if current_log:
        current_attrs = current_log.attributes
        logs = current_attrs.get('logs', [])
        updated_logs = logs[-4:] + [message]  # Keep only the last 5 messages
    else:
        updated_logs = [message]

    new_attrs = {'logs': updated_logs}
    hass.states.set(entity_id, 'active', new_attrs)

# Mapping from short_description to cloud coverage percentage
short_description_to_cloud_coverage = {
    'Mostly Sunny': 20,
    'Mostly Clear': 20,
    'Partly Cloudy': 50,
    'Partly Sunny': 50,
    'Mostly Cloudy': 75,
    'Cloudy': 100,
    'Sunny': 0,
    'Chance Light Snow': 90,      # Assuming heavy cloud cover during snow
    'Slight Chance Light Snow': 80  # Slightly lower cloud cover
    # Add any other mappings as needed
}

# Get the current sun elevation
sun = hass.states.get('sun.sun')
if sun:
    sun_elevation = sun.attributes.get('elevation', -90)
else:
    sun_elevation = -90  # Default value if sun data is not available

# Get the current time and hour
now = hass.states.get('sensor.time').state
current_hour = int(now.split(':')[0])

# Log the current time and hour
log_message(f"Current hour: {current_hour}")

# Get the forecast data from the NWS weather entity
weather_entity = hass.states.get('weather.kfcm_daynight')
forecast_data = weather_entity.attributes.get('forecast', [])

# Log the forecast data
log_message(f"Forecast data: {forecast_data}")

# Default cloud coverage in case no forecast data for current hour is found
cloud_coverage = 0

# Search for the forecast details that matches the current hour
for forecast in forecast_data:
    forecast_hour = int(forecast['datetime'].split('T')[1].split(':')[0])
    log_message(f"Checking forecast hour: {forecast_hour} against current hour: {current_hour}")

    if forecast_hour == current_hour:
        short_description = forecast.get('short_description', '')
        cloud_coverage = short_description_to_cloud_coverage.get(short_description, 0)
        log_message(f"Found matching forecast hour. Short description: '{short_description}', Mapped cloud coverage: {cloud_coverage}")
        break


# Determine light level based on sun elevation and cloud coverage
if sun_elevation <= -5:
    light_level = 'dark'
elif sun_elevation <= 7 or cloud_coverage >= 75:
    light_level = 'dim'
elif sun_elevation <= 30 or cloud_coverage >= 50:
    light_level = 'moderate'
else:
    light_level = 'bright'

# Set state of the sensor with the calculated light level
hass.states.set('sensor.external_light_level', light_level, {
    'elevation': sun_elevation,
    'cloud_coverage': cloud_coverage,
})
