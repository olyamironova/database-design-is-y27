CREATE TABLE ExternalDataSource (
    source_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    api_url TEXT NOT NULL,
    last_fetched TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ExternalWeatherData (
    external_data_id SERIAL PRIMARY KEY,
    source_id INT NOT NULL REFERENCES ExternalDataSource(source_id),
    station_id INT REFERENCES WeatherStation(station_id),
    city_id INT REFERENCES City(city_id),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_type VARCHAR(50) NOT NULL CHECK (data_type IN ('Satellite Image', 'Storm Alert', 'Temperature Anomaly', 'Earthquake', 'Wildfire', 'Flood')),
    data_payload JSON NOT NULL,
    UNIQUE (source_id, station_id, city_id, timestamp)
);
