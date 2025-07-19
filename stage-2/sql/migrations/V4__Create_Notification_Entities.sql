CREATE TABLE Notification (
    notification_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "User"(user_id),
    type VARCHAR(10) NOT NULL CHECK (type IN ('Email', 'SMS', 'Push')),
    message TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE UserNotificationPreferences (
    preference_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "User"(user_id),
    weather_characteristic VARCHAR(50) NOT NULL CHECK (weather_characteristic IN ('Temperature', 'Humidity', 'Pressure', 'Wind Speed', 'Precipitation', 'UV Index', 'Pollen Concentration', 'Geomagnetic Activity', 'AQI')),
    notification_method VARCHAR(10) NOT NULL CHECK (notification_method IN ('Email', 'SMS', 'Push')),
    threshold_level VARCHAR(20) NOT NULL,
    UNIQUE (user_id, weather_characteristic, notification_method)
);