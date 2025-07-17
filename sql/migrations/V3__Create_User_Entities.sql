CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(80),
    password_hash TEXT NOT NULL
);

CREATE TABLE UserHomeLocation (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL UNIQUE REFERENCES Users(user_id),
    city_id INT REFERENCES City(city_id),
    station_id INT REFERENCES WeatherStation(station_id),
    latitude DECIMAL(8,6),
    longitude DECIMAL(9,6),
    CHECK (
        (city_id IS NOT NULL AND station_id IS NULL AND latitude IS NULL AND longitude IS NULL) OR
        (city_id IS NULL AND station_id IS NOT NULL AND latitude IS NULL AND longitude IS NULL) OR
        (city_id IS NULL AND station_id IS NULL AND latitude IS NOT NULL AND longitude IS NOT NULL)
    )
);

CREATE TABLE UserUnitsSettings (
    settings_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    temperature_unit VARCHAR(40) NOT NULL CHECK (temperature_unit IN ('Celsius', 'Fahrenheit')),
    precipitation_unit VARCHAR(20) NOT NULL CHECK (precipitation_unit IN ('mm (rain), cm (snow)', 'inches')),
    wind_speed_unit VARCHAR(50) NOT NULL CHECK (wind_speed_unit IN ('m/s', 'km/h', 'mph', 'knots', 'Beaufort points')),
    pressure_unit VARCHAR(20) NOT NULL CHECK (pressure_unit IN ('mm_of_mercury', 'inches_of_mercury', 'mbar', 'gPa')),
    visibility_unit VARCHAR(5) NOT NULL CHECK (visibility_unit IN ('km', 'miles')),
    update_frequency_in_minutes INT NOT NULL CHECK (update_frequency_in_minutes > 0),
    UNIQUE (user_id)
);

CREATE TABLE UserPollenPreferences (
    preference_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    plant_name VARCHAR(100) NOT NULL,
    notification_threshold DECIMAL(5,2) NOT NULL,
    notify_on_decrease BOOLEAN NOT NULL,
    UNIQUE (user_id, plant_name)
);

CREATE TABLE UserFavoriteLocations (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    city_id INT REFERENCES City(city_id),
    station_id INT REFERENCES WeatherStation(station_id),
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (
        (city_id IS NOT NULL AND station_id IS NULL) OR
        (city_id IS NULL AND station_id IS NOT NULL)
    ),
    UNIQUE (user_id, city_id),
    UNIQUE (user_id, station_id)
);

CREATE TABLE UserHistoryRecentViews (
    view_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    city_id INT NOT NULL REFERENCES City(city_id),
    viewed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, city_id, viewed_at)
);