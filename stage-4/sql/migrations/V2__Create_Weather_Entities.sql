CREATE TABLE WeatherStation (
    station_id SERIAL PRIMARY KEY,
    city_id INT NOT NULL REFERENCES City(city_id),
    latitude DECIMAL(8,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    altitude_above_sea_level_in_metres DECIMAL(7,2) NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    release_date DATE NOT NULL,
    commissioning_date DATE NOT NULL,
    last_maintenance DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Inactive', 'Under Maintenance')),
    UNIQUE (city_id, latitude, longitude)
);

CREATE TABLE Sensor (
    sensor_id SERIAL PRIMARY KEY,
    station_id INT NOT NULL REFERENCES WeatherStation(station_id),
    type VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    last_calibration DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Operational', 'Faulty', 'Maintenance Required')),
    UNIQUE (station_id, type, model)
);

CREATE TABLE WeatherMeasurement (
    measurement_id SERIAL PRIMARY KEY,
    station_id INT NOT NULL REFERENCES WeatherStation(station_id),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    temperature DECIMAL(4,2) NOT NULL,
    dew_point_temperature DECIMAL(4,2) NOT NULL,
    humidity DECIMAL(3,0) NOT NULL,
    pressure DECIMAL(6,2) NOT NULL,
    wind_speed DECIMAL(6,2) NOT NULL,
    wind_direction VARCHAR(2) NOT NULL CHECK (wind_direction IN ('N', 'S', 'W', 'E', 'NW', 'SW', 'SE', 'NE')),
    wind_direction_degrees DECIMAL(3,0) NOT NULL,
    wind_gusts_speed DECIMAL(3,0) NOT NULL,
    precipitation_mm DECIMAL(8,0) NOT NULL,
    precipitation_type VARCHAR(10) NOT NULL CHECK (precipitation_type IN ('Rain', 'Snow', 'Hail', 'Sleet', 'None')),
    uv_index DECIMAL(2,0) NOT NULL,
    visibility DECIMAL(6,0) NOT NULL,
    geomagnetic_activity DECIMAL(2,0) NOT NULL,
    sunrise_time TIME NOT NULL,
    sunset_time TIME NOT NULL,
    aqi DECIMAL(4,0) NOT NULL,
    moon_phase VARCHAR(20) NOT NULL CHECK (moon_phase IN ('Full Moon', 'New Moon', 'First Quarter', 'Last Quarter', 'Growing Sickle', 'Growing Moon', 'Waning Moon', 'Waning Sickle')),
    UNIQUE (station_id, timestamp)
);

CREATE TABLE PollenMeasurement (
    pollen_id SERIAL PRIMARY KEY,
    measurement_id INT NOT NULL REFERENCES WeatherMeasurement(measurement_id),
    plant_name VARCHAR(100) NOT NULL,
    pollen_concentration DECIMAL(5,2) NOT NULL,
    UNIQUE (measurement_id, plant_name)
);

CREATE TABLE HealthRiskLevel (
    parameter VARCHAR(100) NOT NULL CHECK (parameter IN ('UV Index', 'Pollen Concentration', 'Geomagnetic Activity', 'AQI')),
    level VARCHAR(100) NOT NULL CHECK (level IN ('No Activity', 'Low', 'Moderate', 'High', 'Very High', 'Extremely High', 'Calm', 'Mild Storm', 'Moderate Storm', 'Severe Storm', 'Very Severe Storm', 'Extremely Severe Storm')),
    recommendation TEXT NOT NULL,
    PRIMARY KEY (parameter, level)
);

CREATE TABLE MonthlyWeatherStatistics (
    statistics_id SERIAL PRIMARY KEY,
    station_id INT NOT NULL REFERENCES WeatherStation(station_id),
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year INT NOT NULL CHECK (year >= 2000),
    avg_day_temperature DECIMAL(5,2) NOT NULL,
    avg_night_temperature DECIMAL(5,2) NOT NULL,
    avg_humidity DECIMAL(5,2) NOT NULL,
    avg_pressure DECIMAL(6,2) NOT NULL,
    avg_wind_speed DECIMAL(4,2) NOT NULL,
    total_precipitation DECIMAL(5,2) NOT NULL,
    clear_days INT NOT NULL CHECK (clear_days >= 0),
    rainy_days INT NOT NULL CHECK (rainy_days >= 0),
    cloudy_days INT NOT NULL CHECK (cloudy_days >= 0),
    UNIQUE (station_id, month, year)
);