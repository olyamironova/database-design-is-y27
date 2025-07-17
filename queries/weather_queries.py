from typing import List, Dict, Any
import random

class WeatherQueries:
    @staticmethod
    def get_complex_queries() -> List[Dict[str, Any]]:
        return [
            {
                "name": "weather_analysis_by_region",
                "description": "Анализ погодных условий по регионам за последние 30 дней: температура, осадки и медиана.",
                "query": """
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
                """
            },
            {
                "name": "user_activity_analysis",
                "description": "Анализ активности пользователей: избранное, просмотры, уведомления и уровень активности.",
                "query": """
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
                """
            },
            {
                "name": "sensor_performance_analysis",
                "description": "Анализ производительности сенсоров: количество измерений, средние значения по типу.",
                "query": """
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
                """
            },
            {
                "name": "health_recommendation_weather_analysis",
                "description": "Анализ погодных условий и данных о пыльце с выдачей рекомендаций по здоровью на основе UV и аллергенов.",
                "query": """
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
                """
            },
            {
                "name": "station_maintenance_statistics",
                "description": "Статистика технического обслуживания станций и калибровок сенсоров с деталями по сотрудникам.",
                "query": """
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
                """
            },
            {
                "name": "detailed_weather_anomalies_analysis",
                "description": "Анализ климатических аномалий с отклонениями от нормы и сопутствующими предупреждениями.",
                "query": """
                    SELECT 
                        ws.station_id,
                        c.name AS city,
                        r.region_name,
                        co.country_name,
                        wm.timestamp,
                        wm.temperature,
                        (wm.temperature - mws.avg_day_temperature) AS temp_deviation,
                        wm.precipitation_mm,
                        wm.precipitation_type,
                        wm.wind_speed,
                        wm.wind_gusts_speed,
                        uda.data_type AS external_alert,
                        uda.data_payload->>'severity' AS alert_severity,
                        nda.alert_type,
                        nda.alert_level
                    FROM WeatherMeasurement wm
                    JOIN WeatherStation ws ON wm.station_id = ws.station_id
                    JOIN City c ON ws.city_id = c.city_id
                    JOIN Region r ON c.region_id = r.region_id
                    JOIN Country co ON r.country_id = co.country_id
                    JOIN MonthlyWeatherStatistics mws ON (ws.station_id = mws.station_id AND EXTRACT(MONTH FROM wm.timestamp) = mws.month AND EXTRACT(YEAR FROM wm.timestamp) = mws.year)
                    LEFT JOIN ExternalWeatherData uda ON (ws.station_id = uda.station_id AND uda.timestamp BETWEEN wm.timestamp - INTERVAL '1 hour' AND wm.timestamp + INTERVAL '1 hour')
                    LEFT JOIN NaturalDisasterAlert nda ON (ws.station_id = nda.station_id AND nda.alert_time BETWEEN wm.timestamp - INTERVAL '1 hour' AND wm.timestamp + INTERVAL '1 hour')
                    WHERE 
                        (wm.temperature - mws.avg_day_temperature) > 5 OR
                        (wm.temperature - mws.avg_day_temperature) < -5 OR
                        wm.wind_gusts_speed > 20 OR
                        wm.precipitation_mm > 50 OR
                        uda.data_type IS NOT NULL OR
                        nda.alert_id IS NOT NULL
                    ORDER BY temp_deviation DESC
                    LIMIT 200;
                """
            },
            {
                "name": "city_popularity_report",
                "description": "Отчет по популярности городов с использованием оконных функций, медианы и ранжирования.",
                "query": """
                    WITH user_activity AS (
                        SELECT 
                            u.user_id,
                            u.email,
                            COUNT(DISTINCT ufv.view_id) AS views_count,
                            COUNT(DISTINCT ufl.favorite_id) AS favorites_count
                        FROM "User" u
                        LEFT JOIN UserHistoryRecentViews ufv ON u.user_id = ufv.user_id
                        LEFT JOIN UserFavoriteLocations ufl ON u.user_id = ufl.user_id
                        GROUP BY u.user_id, u.email
                    )
                    SELECT 
                        c.city_id,
                        c.name AS city,
                        r.region_name,
                        co.country_name,
                        COUNT(DISTINCT ufv.user_id) AS unique_visitors,
                        COUNT(DISTINCT ufl.user_id) AS users_favorited,
                        AVG(wm.temperature) AS avg_temp,
                        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY wm.temperature) AS median_temp,
                        MAX(wm.temperature) - MIN(wm.temperature) AS temp_range,
                        RANK() OVER (PARTITION BY r.region_id ORDER BY COUNT(DISTINCT ufv.user_id) DESC) AS popularity_rank_in_region,
                        FIRST_VALUE(c.name) OVER (PARTITION BY r.region_id ORDER BY COUNT(DISTINCT ufv.user_id) DESC) AS most_popular_in_region,
                        LEAD(c.name) OVER (PARTITION BY r.region_id ORDER BY COUNT(DISTINCT ufv.user_id) DESC) AS next_popular_in_region
                    FROM City c
                    JOIN Region r ON c.region_id = r.region_id
                    JOIN Country co ON r.country_id = co.country_id
                    LEFT JOIN UserHistoryRecentViews ufv ON c.city_id = ufv.city_id
                    LEFT JOIN UserFavoriteLocations ufl ON c.city_id = ufl.city_id
                    LEFT JOIN WeatherStation ws ON c.city_id = ws.city_id
                    LEFT JOIN WeatherMeasurement wm ON ws.station_id = wm.station_id AND wm.timestamp > NOW() - INTERVAL '7 days'
                    GROUP BY c.city_id, c.name, r.region_id, r.region_name, co.country_name
                    ORDER BY unique_visitors DESC
                    LIMIT 100;
                """
            }
        ]

    @staticmethod
    def get_random_complex_query() -> Dict[str, Any]:
        queries = WeatherQueries.get_complex_queries()
        return random.choice(queries)
