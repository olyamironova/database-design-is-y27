```plantuml
entity WeatherStation {
    +station_id: INT PRIMARY KEY
    ---
    city_id: INT FOREIGN KEY REFERENCES City(city_id)
    latitude: DECIMAL(8,6)
    longitude: DECIMAL(9,6)
    altitude_above_sea_level_in_metres: DECIMAL(7,2)
    manufacturer: VARCHAR(50)
    model: VARCHAR(50)
    release_date: DATE
    commissioning_date: DATE
    last_maintenance: DATE
    status: ENUM('Active', 'Inactive', 'Under Maintenance')
}

entity Sensor {
    +sensor_id: INT PRIMARY KEY
    ---
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id)
    type: VARCHAR(50)
    model: VARCHAR(50)
    last_calibration: DATE
    status: ENUM('Operational', 'Faulty', 'Maintenance Required')
}

entity WeatherMeasurement {
    +measurement_id: INT PRIMARY KEY
    ---
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id)
    timestamp: TIMESTAMP
    temperature: DECIMAL(4,2)
    dew_point_temperature: DECIMAL(4,2)
    humidity: DECIMAL(3,0)
    pressure: DECIMAL(6,2)
    wind_speed: DECIMAL(6,2)
    wind_direction: ENUM('N', 'S', 'W', 'E', 'NW', 'SW', 'SE', 'NE')
    wind_direction_degrees: DECIMAL(3,0)
    wind_gusts_speed: DECIMAL(3,0)
    precipitation_mm: DECIMAL(8,0)
    precipitation_type: ENUM('Rain', 'Snow', 'Hail', 'Sleet', 'None')
    uv_index: DECIMAL(2,0)
    visibility: DECIMAL(6,0)
    geomagnetic_activity: DECIMAL(2,0)
    sunrise_time: TIME
    sunset_time: TIME
    aqi: DECIMAL(4,0)
    moon_phase: ENUM('Full Moon', 'New Moon', 'First Quarter', 'Last Quarter', 'Growing Sickle', 'Growing Moon', 'Waning Moon', 'Waning Sickle')
}

entity HealthRiskLevel {
    +parameter: VARCHAR(20)
    +level: VARCHAR(20)
    ---
    PRIMARY KEY (parameter, level)
    parameter: ENUM('UV Index', 'Pollen Concentration', 'Geomagnetic Activity', 'AQI')
    level: ENUM('No Activity', 'Low', 'Moderate', 'High', 'Very High', 'Extremely High', 'Calm', 'Mild Storm', 'Moderate Storm', 'Severe storm', 'Very Severe storm', 'Extremely severe storm')
    recommendation: TEXT
}

entity PollenMeasurement {
    +pollen_id: INT PRIMARY KEY
    ---
    measurement_id: INT FOREIGN KEY REFERENCES WeatherMeasurement(measurement_id)
    plant_name: VARCHAR(100)
    pollen_concentration: DECIMAL(5,2)
}

entity WeatherStationMaintenance {
    +maintenance_id: INT PRIMARY KEY
    ---
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id)
    maintenance_date: DATE
    technician_id: INT FOREIGN KEY REFERENCES Employee(employee_id)
    description: TEXT
    status_after: ENUM('Operational', 'Requires Repair', 'Decommissioned')
}

entity SensorCalibrationHistory {
    +calibration_id: INT PRIMARY KEY
    ---
    sensor_id: INT FOREIGN KEY REFERENCES Sensor(sensor_id)
    calibration_date: DATE
    technician_id: INT FOREIGN KEY REFERENCES Employee(employee_id)
    calibration_result: ENUM('Successful', 'Failed', 'Requires Further Testing')
    notes: TEXT
}

entity Employee {
    +employee_id: INT PRIMARY KEY
    ---
    first_name: VARCHAR(50)
    last_name: VARCHAR(50)
    patronymic: VARCHAR(50)
    role: ENUM('Administrator', 'Technician', 'Meteorologist')
    email: VARCHAR(100) UNIQUE
    phone: VARCHAR(20)
}

entity User {
    +user_id: INT PRIMARY KEY
    ---
    first_name: VARCHAR(50)
    last_name: VARCHAR(50)
    email: VARCHAR(100) UNIQUE
    phone: VARCHAR(20)
    password_hash: VARCHAR(255)
}

entity UserHomeLocation {
    +favorite_id: INT PRIMARY KEY AUTO_INCREMENT
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id) UNIQUE
    city_id: INT FOREIGN KEY REFERENCES City(city_id) NULLABLE
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id) NULLABLE
    latitude: DECIMAL(8,6) NULLABLE
    longitude: DECIMAL(9,6) NULLABLE
    CHECK (
        (city_id IS NOT NULL AND station_id IS NULL AND latitude IS NULL AND longitude IS NULL) OR
        (city_id IS NULL AND station_id IS NOT NULL AND latitude IS NULL AND longitude IS NULL) OR
        (city_id IS NULL AND station_id IS NULL AND latitude IS NOT NULL AND longitude IS NOT NULL)
    )
}

entity UserUnitsSettings {
    +settings_id: INT PRIMARY KEY
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    temperature_unit: ENUM('Celsius', 'Fahrenheit')
    precipitation_unit: ENUM('mm (rain), cm (snow)', 'inches')
    wind_speed_unit: ENUM('m/s', 'km/h', 'mph', 'knots', 'Beaufort points')
    pressure_unit: ENUM('mm_of_mercury', 'inches_of_mercury', 'mbar', 'gPa')
    visibility_unit: ENUM('km', 'miles')
    update_frequency_in_minutes: INT
}

entity UserPollenPreferences {
    +preference_id: INT PRIMARY KEY
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    plant_name: VARCHAR(100)
    notification_threshold: DECIMAL(5,2)
    notify_on_decrease: BOOLEAN
}

entity UserFavoriteLocations {
    +favorite_id: INT PRIMARY KEY AUTO_INCREMENT
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    city_id: INT FOREIGN KEY REFERENCES City(city_id) NULLABLE
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id) NULLABLE
    added_at: TIMESTAMP
    UNIQUE (user_id, city_id),
    UNIQUE (user_id, station_id)
}

entity UserHistoryRecentViews {
    +view_id: INT PRIMARY KEY
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    city_id: INT FOREIGN KEY REFERENCES City(city_id)
    viewed_at: TIMESTAMP
}

entity City {
    +city_id: INT PRIMARY KEY
    ---
    name: VARCHAR(100)
    region_id: INT FOREIGN KEY REFERENCES Region(region_id)
    latitude: DECIMAL(8,6)
    longitude: DECIMAL(9,6)
}

entity Notification {
    +notification_id: INT PRIMARY KEY
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    type: ENUM('Email', 'SMS', 'Push')
    message: TEXT
    sent_at: TIMESTAMP
}

entity ExternalDataSource {
    +source_id: INT PRIMARY KEY
    ---
    name: VARCHAR(100)
    api_url: TEXT
    last_fetched: TIMESTAMP
}

entity ExternalWeatherData {
    +external_data_id: INT PRIMARY KEY
    ---
    source_id: INT FOREIGN KEY REFERENCES ExternalDataSource(source_id)
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id) NULLABLE
    city_id: INT FOREIGN KEY REFERENCES City(city_id) NULLABLE
    timestamp: TIMESTAMP
    data_type: ENUM('Satellite Image', 'Storm Alert', 'Temperature Anomaly', 'Earthquake', 'Wildfire', 'Flood')
    data_payload: JSON
}

entity UserNotificationPreferences {
    +preference_id: INT PRIMARY KEY
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    weather_characteristic: ENUM('Temperature', 'Humidity', 'Pressure', 'Wind Speed', 'Precipitation', 'UV Index', 'Pollen Concentration', 'Geomagnetic Activity', 'AQI')
    notification_method: ENUM('Email', 'SMS', 'Push')
    threshold_level: VARCHAR(20)
}

entity UserWeatherQuestionnaire {
    +survey_id: INT PRIMARY KEY
    ---
    user_id: INT FOREIGN KEY REFERENCES User(user_id)
    city_id: INT FOREIGN KEY REFERENCES City(city_id)
    survey_time: TIMESTAMP
    condition: ENUM('Rain', 'No Rain', 'Snow', 'No Snow', 'Fog', 'No Fog', 'Clear', 'Storm')
}

entity NaturalDisasterAlert {
    +alert_id: INT PRIMARY KEY
    ---
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id)
    alert_type: ENUM('Earthquake', 'Volcanic Activity', 'Tsunami', 'Fire', 'High Temperature', 'Low Temperature', 'Flood', 'Avalanche', 'Cyclone', 'Tornado', 'Severe Storm')
    alert_level: ENUM('Low', 'Moderate', 'High', 'Very High', 'Extremely High')
    alert_message: TEXT
    alert_time: TIMESTAMP
}

entity MonthlyWeatherStatistics {
    +statistics_id: INT PRIMARY KEY
    ---
    station_id: INT FOREIGN KEY REFERENCES WeatherStation(station_id)
    month: INT
    year: INT
    avg_day_temperature: DECIMAL(5,2)
    avg_night_temperature: DECIMAL(5,2)
    avg_humidity: DECIMAL(5,2)
    avg_pressure: DECIMAL(6,2)
    avg_wind_speed: DECIMAL(4,2)
    total_precipitation: DECIMAL(5,2)
    clear_days: INT
    rainy_days: INT
    cloudy_days: INT
}

entity Country {
  + country_id: INT PRIMARY KEY
  --
  + country_name: VARCHAR(100)
}

entity Region {
  + region_id: INT PRIMARY KEY
  --
  + region_name: VARCHAR(100)
  + country_id: INT FOREIGN KEY REFERENCES Country(country_id)
}

WeatherStation ||--o{ Sensor : has
Employee ||--o{ WeatherStation : manages
User ||--o{ WeatherMeasurement : receives
WeatherStation ||--o{ WeatherMeasurement : collects
User ||--o{ UserNotificationPreferences : sets
UserNotificationPreferences ||--o{ Notification : sends
WeatherStation ||--o{ MonthlyWeatherStatistics : records
User ||--o{ UserWeatherQuestionnaire : submits
WeatherStation ||--o{ NaturalDisasterAlert : issues
User ||--o{ UserPollenPreferences : specifies
UserPollenPreferences ||--o{ Notification : sends
User ||--o{ UserUnitsSettings : configures
UserUnitsSettings ||--o{ WeatherMeasurement : affects
User ||--o{ UserFavoriteLocations : adds
UserFavoriteLocations ||--o{ WeatherStation : references
UserFavoriteLocations ||--o{ City : references
User ||--o{ UserHistoryRecentViews : views
UserHistoryRecentViews ||--o{ City : references
WeatherStation ||--o{ WeatherStationMaintenance : undergoes
WeatherStationMaintenance ||--o{ Employee : performs
Sensor ||--o{ SensorCalibrationHistory : has
SensorCalibrationHistory ||--o{ Employee : performs
WeatherStation ||--o{ PollenMeasurement : collects
PollenMeasurement ||--o{ WeatherMeasurement : references
WeatherStation ||--o{ ExternalWeatherData : references
ExternalWeatherData ||--o{ ExternalDataSource : fetches
ExternalWeatherData ||--o{ City : references
User ||--o{ UserHomeLocation : sets
UserHomeLocation ||--o{ City : references
UserHomeLocation ||--o{ WeatherStation : references
Country ||--o{ Region : has
Region ||--o{ City : has
```