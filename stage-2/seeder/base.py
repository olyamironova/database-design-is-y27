from datetime import datetime, timedelta, time
import json
import psycopg2
from faker import Faker
import random
from psycopg2 import sql
import os
from datetime import datetime, timedelta

fake = Faker()
Faker.seed(42)
random.seed(42)

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "db"),
    "port": int(os.getenv("DB_PORT", '5432')),
    "dbname": os.getenv("DB_NAME", "postgres"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
}
BASE_COUNT = int(os.getenv('SEED_COUNT', 1000))

SEED_COUNTS = {
    'Country': BASE_COUNT,
    'Region': BASE_COUNT * 2,
    'City': BASE_COUNT * 3,
    'WeatherStation': BASE_COUNT * 2,
    'Sensor': BASE_COUNT * 5,
    'Employee': BASE_COUNT,
    'User': BASE_COUNT
}

class DatabaseSeeder:
    def __init__(self):
        self.conn = psycopg2.connect(**DB_CONFIG)
        self.cur = self.conn.cursor()

    def commit(self):
        self.conn.commit()

    def rollback(self):
        self.conn.rollback()

    def close(self):
        self.cur.close()
        self.conn.close()

    def get_or_seed_cities(self):
        self.cur.execute("SELECT city_id FROM City")
        cities = self.cur.fetchall()
        if cities:
            return [row[0] for row in cities]
        return list(self.seed_cities())
    
    def get_or_seed_countries(self):
        self.cur.execute("SELECT country_id FROM Country")
        countries = self.cur.fetchall()
        if countries:
            return [row[0] for row in countries]
        return list(self.seed_countries())
    
    def get_or_seed_regions(self):
        self.cur.execute("SELECT region_id FROM Region")
        regions = self.cur.fetchall()
        if regions:
            return [row[0] for row in regions]
        return list(self.seed_regions())
    
    def get_or_seed_weather_stations(self):
        self.cur.execute("SELECT station_id FROM WeatherStation")
        stations = self.cur.fetchall()
        if stations:
            return [row[0] for row in stations]
        return list(self.seed_weather_stations())

    def seed_countries(self):
        print("Seeding countries...")
        for _ in range(SEED_COUNTS['Country']):
            country_name = fake.country()
            self.cur.execute("SELECT 1 FROM Country WHERE country_name = %s", (country_name,))
            if self.cur.fetchone():
                print(f"Country {country_name} already exists, skipping.", flush=True)
                continue
            self.cur.execute(
                "INSERT INTO Country (country_name) VALUES (%s) RETURNING country_id",
                (country_name,)
            )
            yield self.cur.fetchone()[0]

    
    def seed_regions(self):
        print("Seeding regions...")
        country_ids = list(self.seed_countries())
        for _ in range(SEED_COUNTS['Region']):
            region_name = fake.state()
            self.cur.execute(
                "SELECT 1 FROM Region WHERE region_name = %s", 
                (region_name,)
            )
            if self.cur.fetchone():
                print(f"Region {region_name} already exists, skipping.", flush=True)
                continue
            self.cur.execute(
                "INSERT INTO Region (region_name, country_id) VALUES (%s, %s) RETURNING region_id",
                (region_name, random.choice(country_ids))
            )
            yield self.cur.fetchone()[0]
    
    def seed_cities(self):
        print("Seeding cities...")
        region_ids = list(self.seed_regions())
        for _ in range(SEED_COUNTS['City']):
            city_name = fake.city()
            region_id = random.choice(region_ids)
            
            self.cur.execute(
                "SELECT 1 FROM City WHERE name = %s AND region_id = %s",
                (city_name, region_id)
            )
            if self.cur.fetchone():
                print(f"City {city_name} in region {region_id} already exists, skipping.", flush=True)
                continue
                
            try:
                self.cur.execute(
                    """INSERT INTO City (name, region_id, latitude, longitude)
                    VALUES (%s, %s, %s, %s) RETURNING city_id""",
                    (city_name, region_id,
                    float(fake.latitude()), float(fake.longitude()))
                )
                yield self.cur.fetchone()[0]
            except psycopg2.IntegrityError as e:
                self.rollback()
                print(f"Failed to insert city {city_name}: {e}", flush=True)

    def seed_weather_stations(self):
        print("Seeding weather stations...")
        city_ids = list(self.get_or_seed_cities())
        statuses = ['Active', 'Inactive', 'Under Maintenance']
        manufacturers = ['Acme Weather', 'Global Sensors', 'AtmosTech', 'WeatherMaster', 'ClimatePro']
        models = ['WS-1000', 'ATMOS-500', 'ClimaScan Pro', 'WeatherSense', 'Precision 2000']
        
        for _ in range(SEED_COUNTS['WeatherStation']):
            city_id = random.choice(city_ids)
            latitude = float(fake.latitude())
            longitude = float(fake.longitude())
            
            self.cur.execute(
                "SELECT 1 FROM WeatherStation WHERE city_id = %s AND latitude = %s AND longitude = %s",
                (city_id, latitude, longitude))
            if self.cur.fetchone():
                print(f"Weather station at {latitude},{longitude} already exists, skipping.", flush=True)
                continue
                
            release_date = fake.date_between(start_date='-10y', end_date='-5y')
            commissioning_date = fake.date_between(start_date=release_date, end_date='-1y')
            last_maintenance = fake.date_between(start_date=commissioning_date, end_date='today') if random.random() > 0.3 else None
            
            self.cur.execute(
                """INSERT INTO WeatherStation (
                    city_id, latitude, longitude, altitude_above_sea_level_in_metres,
                    manufacturer, model, release_date, commissioning_date,
                    last_maintenance, status
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING station_id""",
                (
                    city_id, 
                    latitude, 
                    longitude, 
                    round(random.uniform(0, 3000), 2),
                    random.choice(manufacturers), 
                    random.choice(models),
                    release_date, 
                    commissioning_date, 
                    last_maintenance,
                    random.choice(statuses)
                )
            )
            yield self.cur.fetchone()[0]

    def seed_sensors(self):
        print("Seeding sensors...")
        station_ids = list(self.get_or_seed_weather_stations())
        types = ['Temperature', 'Humidity', 'Pressure', 'Wind', 'Precipitation', 'UV', 'Visibility']
        models = ['T-100', 'H-200', 'P-300', 'W-400', 'PR-500', 'UV-600', 'V-700']
        statuses = ['Operational', 'Faulty', 'Maintenance Required']
        
        for _ in range(SEED_COUNTS['Sensor']):
            station_id = random.choice(station_ids)
            sensor_type = random.choice(types)
            model = random.choice(models)
            
            self.cur.execute(
                "SELECT 1 FROM Sensor WHERE station_id = %s AND type = %s AND model = %s",
                (station_id, sensor_type, model))
            if self.cur.fetchone():
                print(f"Sensor {sensor_type} {model} already exists at station {station_id}, skipping.", flush=True)
                continue
                
            last_calibration = fake.date_between(start_date='-2y', end_date='today') if random.random() > 0.2 else None
            
            self.cur.execute(
                """INSERT INTO Sensor (
                    station_id, type, model, last_calibration, status
                ) VALUES (%s, %s, %s, %s, %s) RETURNING sensor_id""",
                (
                    station_id, sensor_type, model, last_calibration,
                    random.choice(statuses)
                )
            )
            yield self.cur.fetchone()[0]

    def seed_weather_measurements(self):
        print("Seeding weather measurements...")
        station_ids = list(self.get_or_seed_weather_stations())
        wind_directions = ['N', 'S', 'W', 'E', 'NW', 'SW', 'SE', 'NE']
        precipitation_types = ['Rain', 'Snow', 'Hail', 'Sleet', 'None']
        moon_phases = ['Full Moon', 'New Moon', 'First Quarter', 'Last Quarter', 
                    'Growing Sickle', 'Growing Moon', 'Waning Moon', 'Waning Sickle']
        
        for station_id in station_ids:
            for _ in range(random.randint(5, 20)):
                timestamp = fake.date_time_between(start_date='-30d', end_date='now')
                
                self.cur.execute(
                    "SELECT 1 FROM WeatherMeasurement WHERE station_id = %s AND timestamp = %s",
                    (station_id, timestamp))
                if self.cur.fetchone():
                    print(f"Measurement at {timestamp} already exists for station {station_id}, skipping.", flush=True)
                    continue
                    
                wind_dir = random.choice(wind_directions)
                wind_deg = {'N': 0, 'S': 180, 'W': 270, 'E': 90,
                        'NW': 315, 'SW': 225, 'SE': 135, 'NE': 45}[wind_dir]
                
                sunrise_hour = random.randint(5, 8)
                sunrise_minute = random.randint(0, 59)
                sunrise = time(sunrise_hour, sunrise_minute).strftime('%H:%M:%S')
                
                sunset_hour = random.randint(17, 21)
                sunset_minute = random.randint(0, 59)
                sunset = time(sunset_hour, sunset_minute).strftime('%H:%M:%S')
                
                self.cur.execute(
                    """INSERT INTO WeatherMeasurement (
                        station_id, timestamp, temperature, dew_point_temperature,
                        humidity, pressure, wind_speed, wind_direction,
                        wind_direction_degrees, wind_gusts_speed, precipitation_mm,
                        precipitation_type, uv_index, visibility, geomagnetic_activity,
                        sunrise_time, sunset_time, aqi, moon_phase
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    RETURNING measurement_id""",
                    (
                        station_id, timestamp,
                        round(random.uniform(-30, 45)),  # temperature
                        round(random.uniform(-35, 40)),  # dew point
                        random.randint(10, 100),  # humidity
                        round(random.uniform(950, 1050), 2),  # pressure
                        round(random.uniform(0, 30), 2),  # wind speed
                        wind_dir, wind_deg,
                        random.randint(0, 50),  # wind gusts
                        round(random.uniform(0, 50)),  # precipitation mm
                        random.choice(precipitation_types),
                        random.randint(0, 12),  # uv index
                        random.randint(100, 10000),  # visibility
                        random.randint(0, 9),  # geomagnetic activity
                        sunrise,  # sunrise time
                        sunset,  # sunset time
                        random.randint(0, 500),  # aqi
                        random.choice(moon_phases)
                    )
                )
                measurement_id = self.cur.fetchone()[0]
                
                if random.random() < 0.3:
                    self.seed_pollen_measurements(measurement_id)
                
                yield measurement_id

    def seed_pollen_measurements(self, measurement_id):
        plants = ['Oak', 'Birch', 'Grass', 'Ragweed', 'Mugwort', 'Olive', 'Cypress']
        
        for plant in random.sample(plants, random.randint(1, 3)):
            self.cur.execute(
                """INSERT INTO PollenMeasurement (
                    measurement_id, plant_name, pollen_concentration
                ) VALUES (%s, %s, %s)""",
                (
                    measurement_id, plant,
                    round(random.uniform(0, 1000), 2)
                )
            )

    def seed_health_risk_levels(self):
        print("Seeding health risk levels...")
        levels = {
            'UV Index': [
                ('No Activity', 'No protection needed'),
                ('Low', 'Wear sunglasses on bright days'),
                ('Moderate', 'Wear sunscreen and a hat'),
                ('High', 'Seek shade during midday hours'),
                ('Very High', 'Use sunscreen and protective clothing'),
                ('Extremely High', 'Avoid sun exposure as much as possible')
            ],
            'Pollen Concentration': [
                ('No Activity', 'No precautions needed'),
                ('Low', 'Sensitive people may experience symptoms'),
                ('Moderate', 'Consider medication if symptomatic'),
                ('High', 'Keep windows closed and limit outdoor time'),
                ('Very High', 'Avoid outdoor activities'),
                ('Extremely High', 'Stay indoors as much as possible')
            ],
            'Geomagnetic Activity': [
                ('Calm', 'No effects expected'),
                ('Mild Storm', 'Possible minor effects on sensitive equipment'),
                ('Moderate Storm', 'Possible effects on satellite operations'),
                ('Severe Storm', 'Possible widespread voltage control problems'),
                ('Very Severe Storm', 'Possible grid system voltage collapse'),
                ('Extremely Severe Storm', 'Possible complete blackout of radio communications')
            ],
            'AQI': [
                ('No Activity', 'Air quality is satisfactory'),
                ('Low', 'Air quality is acceptable'),
                ('Moderate', 'Sensitive groups should limit prolonged outdoor exertion'),
                ('High', 'Everyone may begin to experience health effects'),
                ('Very High', 'Health warnings of emergency conditions'),
                ('Extremely High', 'Health alert: everyone may experience serious health effects')
            ]
        }
        
        for parameter, level_data in levels.items():
            for level, recommendation in level_data:
                self.cur.execute(
                    """INSERT INTO HealthRiskLevel (
                        parameter, level, recommendation
                    ) VALUES (%s, %s, %s)
                    ON CONFLICT (parameter, level) DO NOTHING""",
                    (parameter, level, recommendation)
                )

    def seed_monthly_weather_statistics(self):
        print("Seeding monthly weather statistics...")
        station_ids = list(self.get_or_seed_weather_stations())
        
        for station_id in station_ids:
            for i in range(1, 13):
                year = datetime.now().year
                month = datetime.now().month - i
                if month < 1:
                    month += 12
                    year -= 1
                
                self.cur.execute(
                    "SELECT 1 FROM MonthlyWeatherStatistics WHERE station_id = %s AND month = %s AND year = %s",
                    (station_id, month, year))
                if self.cur.fetchone():
                    print(f"Statistics for {month}/{year} already exist for station {station_id}, skipping.", flush=True)
                    continue
                    
                self.cur.execute(
                    """INSERT INTO MonthlyWeatherStatistics (
                        station_id, month, year, avg_day_temperature, avg_night_temperature,
                        avg_humidity, avg_pressure, avg_wind_speed, total_precipitation,
                        clear_days, rainy_days, cloudy_days
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                    (
                        station_id, month, year,
                        round(random.uniform(-10, 35), 2),  # avg day temp
                        round(random.uniform(-15, 25), 2),  # avg night temp
                        random.randint(30, 90),  # avg humidity
                        round(random.uniform(980, 1030), 2),  # avg pressure
                        round(random.uniform(1, 15), 2),  # avg wind speed
                        round(random.uniform(0, 200), 2),  # total precipitation
                        random.randint(5, 20),  # clear days
                        random.randint(2, 15),  # rainy days
                        random.randint(3, 20)   # cloudy days
                    )
                )
                yield f"{station_id}-{month}-{year}"

    def get_or_seed_weather_stations(self):
        self.cur.execute("SELECT station_id FROM WeatherStation")
        stations = self.cur.fetchall()
        if stations:
            return [row[0] for row in stations]
        return list(self.seed_weather_stations())
    
    def seed_users(self):
        print("Seeding users...")
        for _ in range(SEED_COUNTS['User']):
            first_name = fake.first_name()
            last_name = fake.last_name()
            email = fake.unique.email()
            phone = fake.phone_number() if random.random() > 0.3 else None
            password_hash = fake.sha256()
            
            self.cur.execute(
                """INSERT INTO "User" (
                    first_name, last_name, email, phone, password_hash
                ) VALUES (%s, %s, %s, %s, %s) RETURNING user_id""",
                (first_name, last_name, email, phone, password_hash)
            )
            user_id = self.cur.fetchone()[0]
            yield user_id

    def seed_user_home_locations(self):
        print("Seeding user home locations...")
        user_ids = list(self.get_or_seed_users())
        city_ids = list(self.get_or_seed_cities())
        station_ids = list(self.get_or_seed_weather_stations())
        
        for user_id in user_ids:
            if random.random() > 0.7:
                continue
                
            location_type = random.choice(['city', 'station', 'coordinates'])
            
            if location_type == 'city':
                self.cur.execute(
                    """INSERT INTO UserHomeLocation (
                        user_id, city_id
                    ) VALUES (%s, %s)""",
                    (user_id, random.choice(city_ids))
                )
            elif location_type == 'station':
                self.cur.execute(
                    """INSERT INTO UserHomeLocation (
                        user_id, station_id
                    ) VALUES (%s, %s)""",
                    (user_id, random.choice(station_ids))
                )
            else:
                latitude = float(fake.latitude())
                longitude = float(fake.longitude())
                self.cur.execute(
                    """INSERT INTO UserHomeLocation (
                        user_id, latitude, longitude
                    ) VALUES (%s, %s, %s)""",
                    (user_id, latitude, longitude)
                )

    def seed_user_units_settings(self):
        print("Seeding user units settings...")
        user_ids = list(self.get_or_seed_users())
        
        temperature_units = ['Celsius', 'Fahrenheit']
        precipitation_units = ['mm (rain), cm (snow)', 'inches']
        wind_speed_units = ['m/s', 'km/h', 'mph', 'knots', 'Beaufort points']
        pressure_units = ['mm_of_mercury', 'inches_of_mercury', 'mbar', 'gPa']
        visibility_units = ['km', 'miles']
        
        for user_id in user_ids:
            self.cur.execute(
                """INSERT INTO UserUnitsSettings (
                    user_id, temperature_unit, precipitation_unit,
                    wind_speed_unit, pressure_unit, visibility_unit,
                    update_frequency_in_minutes
                ) VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                (
                    user_id,
                    random.choice(temperature_units),
                    random.choice(precipitation_units),
                    random.choice(wind_speed_units),
                    random.choice(pressure_units),
                    random.choice(visibility_units),
                    random.choice([5, 10, 15, 30, 60])
                )
            )

    def seed_user_pollen_preferences(self):
        print("Seeding user pollen preferences...")
        user_ids = list(self.get_or_seed_users())
        plants = ['Oak', 'Birch', 'Grass', 'Ragweed', 'Mugwort', 'Olive', 'Cypress']
        
        for user_id in user_ids:
            if random.random() > 0.3:
                continue
                
            for plant in random.sample(plants, random.randint(1, 3)):
                self.cur.execute(
                    """INSERT INTO UserPollenPreferences (
                        user_id, plant_name, notification_threshold, notify_on_decrease
                    ) VALUES (%s, %s, %s, %s)""",
                    (
                        user_id,
                        plant,
                        round(random.uniform(10, 500), 2),
                        random.choice([True, False])
                    )
                )

    def seed_user_favorite_locations(self):
        print("Seeding user favorite locations...")
        user_ids = list(self.get_or_seed_users())
        city_ids = list(self.get_or_seed_cities())
        station_ids = list(self.get_or_seed_weather_stations())
        
        for user_id in user_ids:
            for _ in range(random.randint(0, 3)):
                location_type = random.choice(['city', 'station'])
                
                try:
                    if location_type == 'city':
                        self.cur.execute(
                            """INSERT INTO UserFavoriteLocations (
                                user_id, city_id
                            ) VALUES (%s, %s)""",
                            (user_id, random.choice(city_ids))
                        )
                    else:
                        self.cur.execute(
                            """INSERT INTO UserFavoriteLocations (
                                user_id, station_id
                            ) VALUES (%s, %s)""",
                            (user_id, random.choice(station_ids))
                        )
                except psycopg2.IntegrityError:
                    continue

    def seed_user_history_recent_views(self):
        print("Seeding user history recent views...")
        user_ids = list(self.get_or_seed_users())
        city_ids = list(self.get_or_seed_cities())
        
        for user_id in user_ids:
            for city_id in random.sample(city_ids, random.randint(2, min(10, len(city_ids)))):
                for _ in range(random.randint(1, 5)):
                    viewed_at = fake.date_time_between(start_date='-30d', end_date='now')
                    try:
                        self.cur.execute(
                            """INSERT INTO UserHistoryRecentViews (
                                user_id, city_id, viewed_at
                            ) VALUES (%s, %s, %s)""",
                            (user_id, city_id, viewed_at)
                        )
                    except psycopg2.IntegrityError:
                        continue

    def get_or_seed_users(self):
        self.cur.execute('SELECT user_id FROM "User"')
        users = self.cur.fetchall()
        if users:
            return [row[0] for row in users]
        return list(self.seed_users())
    
    def seed_notifications(self):
        print("Seeding notifications...")
        user_ids = list(self.get_or_seed_users())
        notification_types = ['Email', 'SMS', 'Push']
        notification_messages = [
            "Temperature alert: {value}°C",
            "High pollen concentration warning: {value} grains/m³",
            "UV index alert: {value}",
            "Storm warning in your area",
            "Heavy precipitation expected today",
            "Air quality alert: AQI {value}",
            "Extreme weather warning"
        ]
        
        for user_id in user_ids:
            for _ in range(random.randint(0, 5)):
                sent_at = fake.date_time_between(start_date='-30d', end_date='now')
                self.cur.execute(
                    """INSERT INTO Notification (
                        user_id, type, message, sent_at
                    ) VALUES (%s, %s, %s, %s) RETURNING notification_id""",
                    (
                        user_id,
                        random.choice(notification_types),
                        random.choice(notification_messages).format(value=random.randint(1, 100)),
                        sent_at
                    )
                )
                yield self.cur.fetchone()[0]

    def seed_user_notification_preferences(self):
        print("Seeding user notification preferences...")
        user_ids = list(self.get_or_seed_users())
        weather_characteristics = [
            'Temperature', 'Humidity', 'Pressure', 'Wind Speed', 
            'Precipitation', 'UV Index', 'Pollen Concentration', 
            'Geomagnetic Activity', 'AQI'
        ]
        notification_methods = ['Email', 'SMS', 'Push']
        threshold_levels = ['Low', 'Moderate', 'High', 'Very High', 'Extreme']
        
        for user_id in user_ids:
            for characteristic in random.sample(weather_characteristics, random.randint(2, 5)):
                for method in random.sample(notification_methods, random.randint(1, 2)):
                    try:
                        self.cur.execute(
                            """INSERT INTO UserNotificationPreferences (
                                user_id, weather_characteristic, 
                                notification_method, threshold_level
                            ) VALUES (%s, %s, %s, %s)""",
                            (
                                user_id,
                                characteristic,
                                method,
                                random.choice(threshold_levels)
                            )
                        )
                    except psycopg2.IntegrityError:
                        continue

    def seed_external_data_sources(self):
        print("Seeding external data sources...")
        sources = [
            {
                "name": "National Weather Service API",
                "api_url": "https://api.weather.gov/"
            },
            {
                "name": "OpenWeatherMap",
                "api_url": "https://api.openweathermap.org/data/3.0/"
            },
            {
                "name": "WeatherAPI.com",
                "api_url": "https://api.weatherapi.com/v1/"
            },
            {
                "name": "AccuWeather",
                "api_url": "https://dataservice.accuweather.com/"
            },
            {
                "name": "NOAA Climate Data",
                "api_url": "https://www.ncdc.noaa.gov/cdo-web/api/v2/"
            }
        ]
        
        for source in sources:
            self.cur.execute(
                "SELECT 1 FROM ExternalDataSource WHERE name = %s",
                (source["name"],))
            if self.cur.fetchone():
                print(f"Source {source['name']} already exists, skipping.", flush=True)
                continue
                
            last_fetched = fake.date_time_between(start_date='-7d', end_date='now')
            self.cur.execute(
                """INSERT INTO ExternalDataSource (
                    name, api_url, last_fetched
                ) VALUES (%s, %s, %s) RETURNING source_id""",
                (source["name"], source["api_url"], last_fetched)
            )
            yield self.cur.fetchone()[0]

    def seed_external_weather_data(self):
        print("Seeding external weather data...")
        source_ids = list(self.get_or_seed_external_data_sources())
        station_ids = list(self.get_or_seed_weather_stations())
        city_ids = list(self.get_or_seed_cities())
        data_types = ['Satellite Image', 'Storm Alert', 'Temperature Anomaly', 
                    'Earthquake', 'Wildfire', 'Flood']
        
        for source_id in source_ids:
            for _ in range(random.randint(5, 15)):
                if random.choice([True, False]) and station_ids:
                    station_id = random.choice(station_ids)
                    city_id = None
                elif city_ids:
                    city_id = random.choice(city_ids)
                    station_id = None
                else:
                    continue
                    
                data_type = random.choice(data_types)
                timestamp = fake.date_time_between(start_date='-30d', end_date='now')
                
                if data_type == 'Satellite Image':
                    payload = {
                        "image_url": f"https://satellite.example.com/{fake.uuid4()}.jpg",
                        "resolution": f"{random.choice(['low', 'medium', 'high'])}",
                        "coverage_area": random.choice(["regional", "continental", "global"]),
                        "timestamp": timestamp.isoformat()
                    }
                elif data_type == 'Storm Alert':
                    payload = {
                        "severity": random.choice(["minor", "moderate", "severe", "extreme"]),
                        "type": random.choice(["thunderstorm", "hurricane", "tornado", "blizzard"]),
                        "expected_arrival": (timestamp + timedelta(hours=random.randint(1, 72))).isoformat(),
                        "affected_area_km": random.randint(10, 1000)
                    }
                elif data_type == 'Temperature Anomaly':
                    payload = {
                        "baseline_temp": round(random.uniform(-10, 30), 1),
                        "current_temp": round(random.uniform(-15, 45), 1),
                        "deviation": round(random.uniform(1, 15), 1),
                        "duration_hours": random.randint(1, 72)
                    }
                elif data_type == 'Earthquake':
                    payload = {
                        "magnitude": round(random.uniform(1.0, 9.0), 1),
                        "depth_km": round(random.uniform(1, 700), 1),
                        "epicenter": {
                            "latitude": float(fake.latitude()),
                            "longitude": float(fake.longitude())
                        }
                    }
                elif data_type == 'Wildfire':
                    payload = {
                        "size_hectares": random.randint(1, 10000),
                        "containment_percent": random.randint(0, 100),
                        "start_time": (timestamp - timedelta(hours=random.randint(1, 72))).isoformat()
                    }
                elif data_type == 'Flood':
                    payload = {
                        "water_level_meters": round(random.uniform(0.5, 10.0), 1),
                        "rising_speed_cm_per_hour": random.randint(1, 100),
                        "affected_area_km2": random.randint(1, 1000)
                    }
                
                try:
                    self.cur.execute(
                        """INSERT INTO ExternalWeatherData (
                            source_id, station_id, city_id, timestamp,
                            data_type, data_payload
                        ) VALUES (%s, %s, %s, %s, %s, %s)""",
                        (
                            source_id,
                            station_id,
                            city_id,
                            timestamp,
                            data_type,
                            json.dumps(payload)
                        )
                    )
                except psycopg2.IntegrityError:
                    continue

    def get_or_seed_external_data_sources(self):
        self.cur.execute("SELECT source_id FROM ExternalDataSource")
        sources = self.cur.fetchall()
        if sources:
            return [row[0] for row in sources]
        return list(self.seed_external_data_sources())
    

    def seed_employees(self):
        print("Seeding employees...")
        roles = ['Administrator', 'Technician', 'Meteorologist']
        
        for _ in range(SEED_COUNTS['Employee']):
            first_name = fake.first_name()
            last_name = fake.last_name()
            patronymic = fake.first_name() if random.random() > 0.3 else None
            role = random.choice(roles)
            email = f"{first_name.lower()}.{last_name.lower()}@weatherservice.com"
            phone = fake.phone_number()
            
            self.cur.execute("SELECT 1 FROM Employee WHERE email = %s", (email,))
            if self.cur.fetchone():
                email = f"{first_name.lower()}.{last_name.lower()}{random.randint(1, 100)}@weatherservice.com"
            
            try:
                self.cur.execute(
                    """INSERT INTO Employee (
                        first_name, last_name, patronymic, role, email, phone
                    ) VALUES (%s, %s, %s, %s, %s, %s) RETURNING employee_id""",
                    (first_name, last_name, patronymic, role, email, phone)
                )
                yield self.cur.fetchone()[0]
            except psycopg2.IntegrityError:
                print(f"Employee {first_name} {last_name} already exists, skipping.", flush=True)
                continue

    def seed_weather_station_maintenance(self):
        print("Seeding weather station maintenance...")
        station_ids = list(self.get_or_seed_weather_stations())
        technician_ids = list(self.get_or_seed_employees_by_role('Technician'))
        statuses = ['Operational', 'Requires Repair', 'Decommissioned']
        
        for station_id in station_ids:
            for _ in range(random.randint(1, 3)):
                maintenance_date = fake.date_between(start_date='-2y', end_date='today')
                
                self.cur.execute(
                    "SELECT 1 FROM WeatherStationMaintenance WHERE station_id = %s AND maintenance_date = %s",
                    (station_id, maintenance_date))
                if self.cur.fetchone():
                    continue
                    
                self.cur.execute(
                    """INSERT INTO WeatherStationMaintenance (
                        station_id, maintenance_date, technician_id,
                        description, status_after
                    ) VALUES (%s, %s, %s, %s, %s) RETURNING maintenance_id""",
                    (
                        station_id,
                        maintenance_date,
                        random.choice(technician_ids),
                        fake.paragraph(nb_sentences=2),
                        random.choice(statuses)
                    )
                )
                yield self.cur.fetchone()[0]

    def seed_sensor_calibration_history(self):
        print("Seeding sensor calibration history...")
        sensor_ids = list(self.get_or_seed_sensors())
        technician_ids = list(self.get_or_seed_employees_by_role('Technician'))
        calibration_results = ['Successful', 'Failed', 'Requires Further Testing']
        
        for sensor_id in sensor_ids:
            for _ in range(random.randint(1, 5)):
                calibration_timestamp = fake.date_time_between(start_date='-1y', end_date='now')
                
                self.cur.execute(
                    """INSERT INTO SensorCalibrationHistory (
                        sensor_id, calibration_timestamp, technician_id,
                        calibration_result, notes
                    ) VALUES (%s, %s, %s, %s, %s) RETURNING calibration_id""",
                    (
                        sensor_id,
                        calibration_timestamp,
                        random.choice(technician_ids),
                        random.choice(calibration_results),
                        fake.paragraph(nb_sentences=1)
                    )
                )
                yield self.cur.fetchone()[0]

    def get_or_seed_employees_by_role(self, role):
        self.cur.execute("SELECT employee_id FROM Employee WHERE role = %s", (role,))
        employees = self.cur.fetchall()
        if employees:
            return [row[0] for row in employees]
        
        list(self.seed_employees())
        self.cur.execute("SELECT employee_id FROM Employee WHERE role = %s", (role,))
        employees = self.cur.fetchall()
        return [row[0] for row in employees] if employees else []

    def get_or_seed_employees(self):
        self.cur.execute("SELECT employee_id FROM Employee")
        employees = self.cur.fetchall()
        if employees:
            return [row[0] for row in employees]
        return list(self.seed_employees())
    
    def get_or_seed_sensors(self):
        self.cur.execute("SELECT sensor_id FROM Sensor")
        sensors = self.cur.fetchall()
        if sensors:
            return [row[0] for row in sensors]
        return list(self.seed_sensors())

    def seed_user_weather_questionnaires(self):
        print("Seeding user weather questionnaires...")
        user_ids = list(self.get_or_seed_users())
        city_ids = list(self.get_or_seed_cities())
        conditions = ['Rain', 'No Rain', 'Snow', 'No Snow', 'Fog', 'No Fog', 'Clear', 'Storm']
        
        for user_id in user_ids:
            for _ in range(random.randint(1, 5)):
                city_id = random.choice(city_ids)
                survey_time = fake.date_time_between(start_date='-30d', end_date='now')
                condition = random.choice(conditions)
                
                try:
                    self.cur.execute(
                        """INSERT INTO UserWeatherQuestionnaire (
                            user_id, city_id, survey_time, condition
                        ) VALUES (%s, %s, %s, %s) RETURNING survey_id""",
                        (user_id, city_id, survey_time, condition)
                    )
                    yield self.cur.fetchone()[0]
                except psycopg2.IntegrityError:
                    continue

    def seed_natural_disaster_alerts(self):
        print("Seeding natural disaster alerts...")
        station_ids = list(self.get_or_seed_weather_stations())
        alert_types = [
            'Earthquake', 'Volcanic Activity', 'Tsunami', 'Fire',
            'High Temperature', 'Low Temperature', 'Flood',
            'Avalanche', 'Cyclone', 'Tornado', 'Severe Storm'
        ]
        alert_levels = ['Low', 'Moderate', 'High', 'Very High', 'Extremely High']
        
        for station_id in station_ids:
            for _ in range(random.randint(0, 3)):
                alert_type = random.choice(alert_types)
                alert_time = fake.date_time_between(start_date='-30d', end_date='now')
                
                if alert_type == 'Earthquake':
                    magnitude = round(random.uniform(3.0, 9.5), 1)
                    message = f"Earthquake alert: Magnitude {magnitude} detected near station"
                elif alert_type == 'Flood':
                    severity = random.choice(['minor', 'moderate', 'major'])
                    message = f"{severity.capitalize()} flood warning issued for area"
                elif alert_type == 'Fire':
                    acres = random.randint(10, 10000)
                    message = f"Wildfire alert: {acres} acres burning within 50km radius"
                else:
                    message = f"{alert_type} alert: {random.choice(['Developing', 'Imminent', 'Ongoing'])} situation detected"
                
                try:
                    self.cur.execute(
                        """INSERT INTO NaturalDisasterAlert (
                            station_id, alert_type, alert_level,
                            alert_message, alert_time
                        ) VALUES (%s, %s, %s, %s, %s) RETURNING alert_id""",
                        (
                            station_id,
                            alert_type,
                            random.choice(alert_levels),
                            message,
                            alert_time
                        )
                    )
                    yield self.cur.fetchone()[0]
                except psycopg2.IntegrityError:
                    continue