CREATE EXTENSION IF NOT EXISTS pgfaker;

CREATE TABLE Country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Region (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL UNIQUE,
    country_id INT NOT NULL REFERENCES Country(country_id)
);

CREATE TABLE City (
    city_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region_id INT NOT NULL REFERENCES Region(region_id),
    latitude DECIMAL(8,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    UNIQUE (name, region_id)
);