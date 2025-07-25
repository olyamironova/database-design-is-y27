# Функциональные требования "Сеть метеорологических станций"

## Требования к управлению данными
1. База данных должна поддерживать хранение следующих метеорологических параметров:
  - Температура воздуха
  - Облачность (ясно, малооблачно, облачно, пасмурно, дождь, снег, снег с дождем, ливень)
  - Явления погоды (гроза, град, шквал, туман, гололед, изморозь, налипание (отложение) мокрого снега на провода (проводах) и деревья (деревьях), метель, пыльная (песчаная) буря, гололедица на дорогах, снежные заносы на дорогах)
  - Влажность
  - Точка росы
  - Атмосферное давление
  - Скорость и направление ветра, скорость порывов ветра
  - Количество осадков
  - Ультрафиолетовый индекс
  - Видимость
  - Вид растения и концентрация его пыльцы в атмосферном воздухе
  - Геомагнитная активность
  - Индекс качества воздуха (AQI)
  - Время восхода и заката солнца
  - Фаза луны
2. База данных должна поддерживать хранение следующих характеристик имеющихся метеорологических станций:
  - Географические координаты станции (широта, долгота, высота над уровнем моря)
  - Идентификатор станции
  - Производитель, модель, дата выпуска, дата введения в эксплуатацию, даты проведения технического обслуживания, состояние датчика
3. База данных должна поддерживать хранение сведений о сотрудниках (администратор, технический специалист, метеоролог) и их правах доступа к данным.
4. База данных должна поддерживать хранение сведений о пользователях.
5. База данных должна поддерживать хранение дифференцировки показателей УФ-излучения, концентрации пыльцы, геомагнитной активности, AQI по уровням опасности для здоровья (каким численным показателям какой уровень опасности соответствует): низкий, умеренный, высокий, очень высокий, крайне высокий.
6. База данных должна поддерживать автоматическое получение данных с метеорологических станций в реальном времени.
7. Все показатели, снятые с датчиков, должны быть снабжены временными метками для точного отслеживания времени сбора.
8. База данных должна поддерживать принадлежность метеорологической станции к городу (району, населенному пункту).
9. База данных должна поддерживать хранение исторических данных для формирования статистики.
10. База данных должна поддерживать хранение и отображение данных на нескольких языках.
11. База данных должна поддерживать интеграцию с внешними API для получения дополнительных метеорологических данных (например, спутниковые данные, данные о природных катастрофах).
12. База данных должна поддерживать хранение пользовательских настроек и предпочтений, таких как предпочитаемые единицы измерения, частота обновления данных и т.д.
13. База данных должна поддерживать хранение перечня избранных городов для каждого пользователя.
14. База данных должна поддерживать хранение списка погодных характеристик, об изменениях которых пользователь хочет получать уведомления, и прироритетный способ уведомления.
15. Технический специалист имеет возможность добавить новую метеорологическую станцию в базу.
    
## Требования к взаимодействию с пользователем
Управление пользователями:
1. Регистрация пользователя
  - Пользователь переходит на страницу регистрации через веб-браузер или мобильное приложение.
  - Пользователь вводит личные данные.
  - Пользователь вводит логин (имя пользователя), который проходит проверку на уникальность.
  - Пользователь создает надежный пароль, соответствующий требованиям безопасности.
  - Система отправляет на указанный адрес электронной почты ссылку для подтверждения регистрации.
  - Пользователь переходит по ссылке из письма, чтобы подтвердить свой адрес электронной почты и завершить процесс регистрации.
2. Авторизация
  - После успешной регистрации пользователь может войти в систему, используя свой логин и пароль.
  - Система проверяет введенные данные и предоставляет доступ к личному кабинету пользователя.
3. Восстановление пароля
  - Если пользователь забыл свой пароль, он может перейти на страницу восстановления пароля.
  - Пользователь вводит адрес электронной почты, указанный при регистрации.
  - Система отправляет на указанный адрес электронной почты ссылку для восстановления пароля.
  - Ссылка действительна в течение ограниченного времени (24 часа) для обеспечения безопасности.
  - Пользователь переходит по ссылке из письма и попадает на страницу создания нового пароля.
  - Пользователь вводит новый пароль, соответствующий требованиям безопасности, и подтверждает его повторным введением.

Профиль пользователя состоит из следующих параметров:
- Личные данные:
  - Имя, фамилия
  - Адрес электронной почты
  - Номер телефона (опционально)
- Пользовательские настройки:
  - Единицы измерения  
    Пользователь может выбирать единицы измерения, в которых будет отображаться погода, и переключаться с одних единиц на другие (температура: °C, °F; осадки: мм (дождь), см (снег), дюймы; ветер: м/с, км/ч, мили/час, узлы, баллы Бофорта; давление: мм рт. ст., дюймы рт. ст., мбар, гПа; горизонтальная видимость: км, мили).
  - Частота обновления данных
  - Избранные  
    Пользователь составляет для себя подборку городов (районов, населенных пунктов), погоду в которых можно посмотреть без необходимости искать каждый город в поисковой строке (все города в отдельном разделе в одном месте, пользователь заходит в раздел и получает доступ к погоде сразу по всем городам).
  - Приоритетное местоположение ("Дом"), для которого погода будет выводиться по умолчанию.
  - Способ получения уведомлений о важных погодных событиях (электронная почта, SMS, push-уведомления).
  - Настройки уведомлений:
    - Концентрация пыльцы  
      - Флаг на отправку уведомлений о пыльце (хочет ли пользовать получать уведомления, отметит в личном кабинете).
      - Виды растений, информация о концентрации пыльцы которых интересует пользователя.
      - Уровня концентрации пыльцы в воздухе (активности нет, низкая, умеренная, высокая), при достижении которого (и выше) пользователь хочет получать уведомления.
      - Флаг на отправку уведомлений при снижении уровня концентрации пыльцы (опциональное уведомление).
    - Ультрафиолетовый индекс  
      - Уровень УФ-индекса (низкий, умеренный, высокий, очень высокий, крайне высокий), при достижении которого (и выше) пользователю будут приходить уведомления об уровне УФ-индекса и рекомендации (необходимо защищаться от солнца, лучше не выходить на улицу и т.д.).
    - Геомагнитная активность  
      - Уровень геомагнитной активности (спокойное, слабая буря, умеренная буря, сильная буря, очень сильная буря, экстремально сильная буря), при достижении которого (и выше) пользователю будут приходить уведомления о наступлении уровня геомагнитной активности.
  - Недавние  
    Хранение данных о ранее просмотренных прогнозах.
    
1. Система должна поддерживать режим идентификации, авторизации и аутентификации.
2. Система автоматически определяет текущее местоположение по геолокации и предложение погоды на основании текущего положения.
3. Пользователь может настроить приоритетное местоположение ("Дом"), для которого погода будет выводиться по умолчанию, указав название города (района, населенного пункта) и страны или географические координаты местоположения.
4. Пользователь может найти в поисковой строке населенный пункт, город или район для просмотра погоды.
5. Пользователь может выбрать промежуток длительностью от 1 до 14 дней, за который он хочет посмотреть прогноз погоды.
6. Фильтрация метеорологических показателей в сформированном отчете на заданное количество дней (по выборке данных из предыдущего пункта берем только те показатели, которые нужны). 
7. Пользователь может просматривать тенденцию изменения температуры в один и тот же день в разные годы.
8. Пользователь может открыть просмотр погоды на карте.
9. Пользователь может посмотреть статистику усредненных данных за последние 10 лет по каждому месяцу (средняя дневная и ночная температура, облачность, влажность воздуха, количество осадков, направление и скорость ветра, статистика по каждому месяцу количества ясных дней, дней с длительными осадками, дней с переменной облачностью).
10. Система должна реализовывать опрос пользователей о погоде в настоящий момент ("Идёт дождь" или "Нет дождя", "Идёт снег"  или "Нет снега" и т.п.), который позволяет уточнить погоду в данное время в конкретном месте.
11. Пользователь может настроить под себя единицы измерения, частоту обновления данных, составить список избранных городов.
12. Пользователь может посмотреть историю недавних запросов.
13. Пользователь может настроить способ получения уведомлений (электронная почта, SMS, push-уведомления) о важных погодных событиях или предупреждения о повышении ультрафиолетового излучения, повышения концентрации пыльцы и т.д.
14. Система должна поддерживать отправку уведомлений пользователям посредством электронной почты, SMS, push-уведомления.
15. База данных должна поддерживать обязательную отправку уведомлений и оповещений пользователям о явлениях природного характера (землетрясения, активности вулканов, цунами, пожары, высокие и низкие температуры, угрожающие жизни и здоровью людей, наводнения, лавины, циклоны, шторы, ураганы, смерчи, сильные грозы) (аналог предупреждения от МЧС).
16. Пользователь может указать виды растений, информация о концентрации пыльцы которых его интересует.
17. Пользователь может указать уровень концентрации пыльцы в атмосферном воздухе, при достижении которого (и выше) он хочет получать уведомления.
18. Пользователь может указать, хочет ли он получать уведомления о снижении уровня концентрации пыльцы.
19. Пользователь может указать, хочет ли он получать уведомления об ультрафиолетовой активности.
20. Пользователь может указать уровень УФ-излучения, при достижении которого (и выше) он хочет получать уведомления.
21. Пользователь может указать, хочет ли он получать уведомления о геомагнитной активности.
22. Пользователь может указать уровень геомагнитной активности, при достижении которого (и выше) он хочет получать уведомления.

## Проверка отношений на соответствие 3НФ
1. WeatherStation
- Первичный ключ: station_id
- Внешние ключи: city_id
- Атрибуты: latitude, longitude, altitude_above_sea_level_in_metres, manufacturer, model, release_date, commissioning_date, last_maintenance, status
- Все атрибуты зависят только от station_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

2. Sensor
- Первичный ключ: sensor_id
- Внешние ключи: station_id
- Атрибуты: type, model, last_calibration, status
- Все атрибуты зависят только от sensor_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

3. WeatherMeasurement
- Первичный ключ: measurement_id
- Внешние ключи: station_id
- Атрибуты: timestamp, temperature, dew_point_temperature, humidity, pressure, wind_speed, wind_direction, wind_direction_degrees, wind_gusts_speed, precipitation_mm, precipitation_type, uv_index, visibility, geomagnetic_activity, sunrise_time, sunset_time, aqi, moon_phase
- Все атрибуты зависят только от measurement_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

4. HealthRiskLevel
- Первичный ключ: (parameter, level)
- Атрибуты: recommendation
- Все атрибуты зависят только от комбинации parameter и level.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

5. PollenMeasurement
- Первичный ключ: pollen_id
- Внешние ключи: measurement_id
- Атрибуты: plant_name, pollen_concentration
- Все атрибуты зависят только от pollen_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

6. WeatherStationMaintenance
- Первичный ключ: maintenance_id
- Внешние ключи: station_id, technician_id
- Атрибуты: maintenance_date, description, status_after
- Все атрибуты зависят только от maintenance_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

7. SensorCalibrationHistory
- Первичный ключ: calibration_id
- Внешние ключи: sensor_id, technician_id
- Атрибуты: calibration_date, calibration_result, notes
- Все атрибуты зависят только от calibration_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

8. Employee
- Первичный ключ: employee_id
- Атрибуты: first_name, last_name, patronymic, role, email, phone
- Все атрибуты зависят только от employee_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

9. User
- Первичный ключ: user_id
- Атрибуты: first_name, last_name, email, phone, password_hash
- Все атрибуты зависят только от user_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

10. UserHomeLocation
- Первичный ключ: favorite_id
- Внешние ключи: user_id, city_id, station_id
- Атрибуты: latitude, longitude
- Все атрибуты зависят только от favorite_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

11. UserUnitsSettings
- Первичный ключ: settings_id
- Внешние ключи: user_id
- Атрибуты: temperature_unit, precipitation_unit, wind_speed_unit, pressure_unit, visibility_unit, update_frequency_minutes
- Все атрибуты зависят только от settings_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

12. UserPollenPreferences
- Первичный ключ: preference_id
- Внешние ключи: user_id
- Атрибуты: plant_name, notification_threshold, notify_on_decrease
- Все атрибуты зависят только от preference_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

13. UserFavoriteLocations
- Первичный ключ: favorite_id
- Внешние ключи: user_id, city_id, station_id
- Атрибуты: added_at
- Все атрибуты зависят только от favorite_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

14. UserHistoryRecentViews
- Первичный ключ: view_id
- Внешние ключи: user_id, city_id
- Атрибуты: viewed_at
- Все атрибуты зависят только от view_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

15. City
- Первичный ключ: city_id
- Атрибуты: name, region, country, latitude, longitude
- Все атрибуты зависят только от city_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

16. Notification
- Первичный ключ: notification_id
- Внешние ключи: user_id
- Атрибуты: type, message, sent_at
- Все атрибуты зависят только от notification_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

17. ExternalDataSource
- Первичный ключ: source_id
- Атрибуты: name, api_url, last_fetched
- Все атрибуты зависят только от source_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

18. ExternalWeatherData
- Первичный ключ: external_data_id
- Внешние ключи: source_id, station_id, city_id
- Атрибуты: timestamp, data_type, data_payload
- Все атрибуты зависят только от external_data_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

19. UserNotificationPreferences
- Первичный ключ: preference_id
- Внешние ключи: user_id
- Атрибуты: weather_characteristic, notification_method, pollen_threshold_level, uv_threshold_level, geomagnetic_threshold, notify_on_pollen_decrease, notify_on_uv_activity, notify_on_geomagnetic_activity
- Все атрибуты зависят только от preference_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

20. UserWeatherQuestionnaire
- Первичный ключ: survey_id
- Внешние ключи: user_id, city_id
- Атрибуты: survey_time, condition
- Все атрибуты зависят только от survey_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

21. NaturalDisasterAlert
- Первичный ключ: alert_id
- Внешние ключи: city_id
- Атрибуты: alert_type, alert_level, alert_message, alert_time
- Все атрибуты зависят только от alert_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

22. MonthlyWeatherStatistics
- Первичный ключ: statistics_id
- Внешние ключи: station_id
- Атрибуты: month, year, avg_day_temperature, avg_night_temperature, avg_humidity, avg_pressure, avg_wind_speed, total_precipitation, clear_days, rainy_days, cloudy_days
- Все атрибуты зависят только от statistics_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

23. Country
- Первичный ключ: country_id
- Атрибуты: country_name
- Атрибут country_name зависит только от первичного ключа country_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

24. Region
- Первичный ключ: region_id
- Внешние ключи: country_id
- Атрибуты: region_name
- Атрибут region_name зависит только от первичного ключа region_id.
- Атрибут country_id является внешним ключом, который ссылается на таблицу Country, и зависит только от первичного ключа region_id.
- Нет транзитивных зависимостей.
- **Вывод:** таблица соответствует 3НФ.

Замечание: таблица, в которой одновременно находились бы город, регион и страна, не удовлетворяла бы третьей нормальной форме (3НФ), поскольку была бы транзитивная функциональная зависимость: город зависит от региона, а регион от страны.  
Каждая таблица соответствует требованиям третьей нормальной формы: все атрибуты зависят только от первичного ключа, и нет транзитивных зависимостей. Таким образом, дизайн этих таблиц удовлетворяет условиям 3НФ, что и требовалось доказать.