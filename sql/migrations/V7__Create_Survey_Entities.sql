CREATE TABLE UserWeatherQuestionnaire (
    survey_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    city_id INT NOT NULL REFERENCES City(city_id),
    survey_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    condition VARCHAR(20) NOT NULL CHECK (condition IN ('Rain', 'No Rain', 'Snow', 'No Snow', 'Fog', 'No Fog', 'Clear', 'Storm')),
    UNIQUE (user_id, city_id, survey_time)
);

CREATE TABLE NaturalDisasterAlert (
    alert_id SERIAL PRIMARY KEY,
    station_id INT NOT NULL REFERENCES WeatherStation(station_id),
    alert_type VARCHAR(50) NOT NULL CHECK (alert_type IN ('Earthquake', 'Volcanic Activity', 'Tsunami', 'Fire', 'High Temperature', 'Low Temperature', 'Flood', 'Avalanche', 'Cyclone', 'Tornado', 'Severe Storm')),
    alert_level VARCHAR(20) NOT NULL CHECK (alert_level IN ('Low', 'Moderate', 'High', 'Very High', 'Extremely High')),
    alert_message TEXT NOT NULL,
    alert_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (station_id, alert_type, alert_time)
);