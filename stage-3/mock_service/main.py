import os
from fastapi import FastAPI, Depends
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

DATABASE_URL = (
    f"postgresql+asyncpg://{os.getenv('DB_USER', 'migration_admin')}:"
    f"{os.getenv('DB_PASSWORD', 'migration_admin')}@"
    f"{os.getenv('DB_HOST', 'localhost')}:{os.getenv('DB_PORT', '5432')}/"
    f"{os.getenv('DB_NAME', 'weather')}"
)

engine = create_async_engine(DATABASE_URL, echo=True)
async_session = async_sessionmaker(engine, expire_on_commit=False)

app = FastAPI()

async def get_db():
    async with async_session() as session:
        yield session


@app.get("/report/weather-analysis-by-region")
async def weather_analysis_by_region(db: AsyncSession = Depends(get_db)):
    query = text("""
        SELECT 
            r.region_name,
            c.name AS city,
            COUNT(wm.measurement_id) AS measurements_count,
            AVG(wm.temperature) AS avg_temp,
            MAX(wm.temperature) AS max_temp,
            MIN(wm.temperature) AS min_temp,
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY wm.temperature) AS median_temp,
            SUM(wm.precipitation_mm) AS total_precipitation
        FROM WeatherMeasurement wm
        JOIN WeatherStation ws ON wm.station_id = ws.station_id
        JOIN City c ON ws.city_id = c.city_id
        JOIN Region r ON c.region_id = r.region_id
        WHERE wm.timestamp BETWEEN NOW() - INTERVAL '30 days' AND NOW()
        GROUP BY ROLLUP(r.region_name, c.name)
        ORDER BY r.region_name, total_precipitation DESC
        LIMIT 100;
    """)
    result = await db.execute(query)
    return [dict(row._mapping) for row in result]


@app.get("/report/user-activity")
async def user_activity_analysis(db: AsyncSession = Depends(get_db)):
    query = text("""
        WITH user_stats AS (
            SELECT 
                u.user_id,
                u.email,
                COUNT(DISTINCT f.favorite_id) AS favorites_count,
                COUNT(DISTINCT v.view_id) AS views_count,
                COUNT(DISTINCT n.notification_id) AS notifications_received
            FROM "User" u
            LEFT JOIN UserFavoriteLocations f ON u.user_id = f.user_id
            LEFT JOIN UserHistoryRecentViews v ON u.user_id = v.user_id
            LEFT JOIN Notification n ON u.user_id = n.user_id
            GROUP BY u.user_id, u.email
        )
        SELECT 
            user_id,
            email,
            favorites_count,
            views_count,
            notifications_received,
            CASE 
                WHEN views_count > 100 THEN 'high'
                WHEN views_count > 50 THEN 'medium'
                ELSE 'low'
            END AS activity_level
        FROM user_stats
        ORDER BY views_count DESC;
    """)
    result = await db.execute(query)
    return [dict(row._mapping) for row in result]


@app.get("/report/sensor-performance")
async def sensor_performance_analysis(db: AsyncSession = Depends(get_db)):
    query = text("""
        SELECT 
            s.sensor_id,
            s.type,
            s.model,
            COUNT(wm.measurement_id) AS measurements_count,
            AVG(CASE WHEN s.type = 'temperature' THEN wm.temperature END) AS avg_temp,
            AVG(CASE WHEN s.type = 'humidity' THEN wm.humidity END) AS avg_humidity,
            ws.status AS station_status
        FROM Sensor s
        JOIN WeatherStation ws ON s.station_id = ws.station_id
        LEFT JOIN WeatherMeasurement wm ON ws.station_id = wm.station_id
        WHERE wm.timestamp > NOW() - INTERVAL '7 days'
        GROUP BY s.sensor_id, s.type, s.model, ws.status
        HAVING COUNT(wm.measurement_id) > 0
        ORDER BY measurements_count DESC;
    """)
    result = await db.execute(query)
    return [dict(row._mapping) for row in result]


@app.get("/report/health-recommendations")
async def health_recommendation_weather_analysis(db: AsyncSession = Depends(get_db)):
    query = text("""
        SELECT 
            u.user_id,
            u.email,
            c.name AS city,
            r.region_name,
            co.country_name,
            wm.timestamp,
            wm.temperature,
            wm.uv_index,
            wm.aqi,
            pm.plant_name,
            pm.pollen_concentration,
            hrl.recommendation AS health_recommendation
        FROM "User" u
        JOIN UserHomeLocation uhl ON u.user_id = uhl.user_id
        LEFT JOIN City c ON uhl.city_id = c.city_id
        LEFT JOIN Region r ON c.region_id = r.region_id
        LEFT JOIN Country co ON r.country_id = co.country_id
        LEFT JOIN WeatherStation ws ON (uhl.station_id = ws.station_id OR ws.city_id = c.city_id)
        LEFT JOIN WeatherMeasurement wm ON ws.station_id = wm.station_id
        LEFT JOIN PollenMeasurement pm ON wm.measurement_id = pm.measurement_id
        LEFT JOIN HealthRiskLevel hrl ON (
            (hrl.parameter = 'UV Index' AND hrl.level = 
                CASE 
                    WHEN wm.uv_index <= 2 THEN 'Low'
                    WHEN wm.uv_index <= 5 THEN 'Moderate'
                    WHEN wm.uv_index <= 7 THEN 'High'
                    WHEN wm.uv_index <= 10 THEN 'Very High'
                    ELSE 'Extremely High'
                END)
            OR
            (hrl.parameter = 'Pollen Concentration' AND hrl.level = 
                CASE 
                    WHEN pm.pollen_concentration <= 30 THEN 'Low'
                    WHEN pm.pollen_concentration <= 90 THEN 'Moderate'
                    WHEN pm.pollen_concentration <= 150 THEN 'High'
                    ELSE 'Very High'
                END)
        )
        WHERE wm.timestamp > NOW() - INTERVAL '24 hours'
        ORDER BY u.user_id, wm.timestamp DESC
        LIMIT 1000;
    """)
    result = await db.execute(query)
    return [dict(row._mapping) for row in result]


@app.get("/report/station-maintenance")
async def station_maintenance_statistics(db: AsyncSession = Depends(get_db)):
    query = text("""
        SELECT 
            ws.station_id,
            c.name AS city,
            COUNT(wsm.maintenance_id) AS maintenance_count,
            AVG(EXTRACT(EPOCH FROM (wsm.maintenance_date - ws.last_maintenance))) / 86400 AS avg_days_between_maintenance,
            e.employee_id,
            e.first_name || ' ' || e.last_name AS technician_name,
            e.role,
            COUNT(sch.calibration_id) AS calibrations_done,
            ROUND(100.0 * SUM(CASE WHEN sch.calibration_result = 'Successful' THEN 1 ELSE 0 END) / COUNT(sch.calibration_id), 2) AS success_rate
        FROM WeatherStation ws
        JOIN City c ON ws.city_id = c.city_id
        LEFT JOIN WeatherStationMaintenance wsm ON ws.station_id = wsm.station_id
        LEFT JOIN Employee e ON wsm.technician_id = e.employee_id
        LEFT JOIN Sensor s ON ws.station_id = s.station_id
        LEFT JOIN SensorCalibrationHistory sch ON s.sensor_id = sch.sensor_id
        GROUP BY ws.station_id, c.name, e.employee_id, e.first_name, e.last_name, e.role
        HAVING COUNT(wsm.maintenance_id) > 0
        ORDER BY maintenance_count DESC
        LIMIT 50;
    """)
    result = await db.execute(query)
    return [dict(row._mapping) for row in result]
