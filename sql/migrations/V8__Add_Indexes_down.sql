DROP INDEX IF EXISTS idx_city_region_id;
DROP INDEX IF EXISTS idx_region_country_id;
DROP INDEX IF EXISTS idx_station_city_id;
DROP INDEX IF EXISTS idx_sensor_station_id;
DROP INDEX IF EXISTS idx_measurement_station_id;
DROP INDEX IF EXISTS idx_pollen_measurement_id;

DROP INDEX IF EXISTS idx_userprefs_user_id;
DROP INDEX IF EXISTS idx_userfav_user_id;
DROP INDEX IF EXISTS idx_userhist_user_id;
DROP INDEX IF EXISTS idx_userprefs_characteristic;

DROP INDEX IF EXISTS idx_measurement_timestamp;
DROP INDEX IF EXISTS idx_userhistory_viewed_at;
DROP INDEX IF EXISTS idx_notification_sent_at;
DROP INDEX IF EXISTS idx_external_timestamp;