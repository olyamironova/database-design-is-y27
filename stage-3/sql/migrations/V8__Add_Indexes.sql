CREATE INDEX IF NOT EXISTS idx_city_region_id ON City(region_id);
CREATE INDEX IF NOT EXISTS idx_region_country_id ON Region(country_id);
CREATE INDEX IF NOT EXISTS idx_station_city_id ON WeatherStation(city_id);
CREATE INDEX IF NOT EXISTS idx_sensor_station_id ON Sensor(station_id);
CREATE INDEX IF NOT EXISTS idx_measurement_station_id ON WeatherMeasurement(station_id);
CREATE INDEX IF NOT EXISTS idx_pollen_measurement_id ON PollenMeasurement(measurement_id);

CREATE INDEX IF NOT EXISTS idx_userprefs_user_id ON UserNotificationPreferences(user_id);
CREATE INDEX IF NOT EXISTS idx_userfav_user_id ON UserFavoriteLocations(user_id);
CREATE INDEX IF NOT EXISTS idx_userhist_user_id ON UserHistoryRecentViews(user_id);
CREATE INDEX IF NOT EXISTS idx_userprefs_characteristic ON UserNotificationPreferences(weather_characteristic);

CREATE INDEX IF NOT EXISTS idx_measurement_timestamp ON WeatherMeasurement(timestamp);
CREATE INDEX IF NOT EXISTS idx_userhistory_viewed_at ON UserHistoryRecentViews(viewed_at);
CREATE INDEX IF NOT EXISTS idx_notification_sent_at ON Notification(sent_at);
CREATE INDEX IF NOT EXISTS idx_external_timestamp ON ExternalWeatherData(timestamp);
