CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    role VARCHAR(40) NOT NULL CHECK (role IN ('Administrator', 'Technician', 'Meteorologist')),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(80) NOT NULL,
    UNIQUE (first_name, last_name, patronymic, email)
);

CREATE TABLE WeatherStationMaintenance (
    maintenance_id SERIAL PRIMARY KEY,
    station_id INT NOT NULL REFERENCES WeatherStation(station_id),
    maintenance_date DATE NOT NULL,
    technician_id INT NOT NULL REFERENCES Employee(employee_id),
    description TEXT NOT NULL,
    status_after VARCHAR(20) NOT NULL CHECK (status_after IN ('Operational', 'Requires Repair', 'Decommissioned')),
    UNIQUE (station_id, maintenance_date)
);

CREATE TABLE SensorCalibrationHistory (
    calibration_id SERIAL PRIMARY KEY,
    sensor_id INT NOT NULL REFERENCES Sensor(sensor_id),
    calibration_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    technician_id INT NOT NULL REFERENCES Employee(employee_id),
    calibration_result VARCHAR(40) NOT NULL CHECK (calibration_result IN ('Successful', 'Failed', 'Requires Further Testing')),
    notes TEXT NOT NULL
);