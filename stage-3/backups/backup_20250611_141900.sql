--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-0+deb12u1)
-- Dumped by pg_dump version 16.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    user_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(80),
    password_hash text NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: User_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_user_id_seq" OWNER TO postgres;

--
-- Name: User_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_user_id_seq" OWNED BY public."User".user_id;


--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city (
    city_id integer NOT NULL,
    name character varying(100) NOT NULL,
    region_id integer NOT NULL,
    latitude numeric(8,6) NOT NULL,
    longitude numeric(9,6) NOT NULL
);


ALTER TABLE public.city OWNER TO postgres;

--
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.city_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.city_city_id_seq OWNER TO postgres;

--
-- Name: city_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.city_city_id_seq OWNED BY public.city.city_id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.country (
    country_id integer NOT NULL,
    country_name character varying(100) NOT NULL
);


ALTER TABLE public.country OWNER TO postgres;

--
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.country_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.country_country_id_seq OWNER TO postgres;

--
-- Name: country_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.country_country_id_seq OWNED BY public.country.country_id;


--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    patronymic character varying(50),
    role character varying(40) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(80) NOT NULL,
    CONSTRAINT employee_role_check CHECK (((role)::text = ANY ((ARRAY['Administrator'::character varying, 'Technician'::character varying, 'Meteorologist'::character varying])::text[])))
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_employee_id_seq OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_employee_id_seq OWNED BY public.employee.employee_id;


--
-- Name: externaldatasource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externaldatasource (
    source_id integer NOT NULL,
    name character varying(100) NOT NULL,
    api_url text NOT NULL,
    last_fetched timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.externaldatasource OWNER TO postgres;

--
-- Name: externaldatasource_source_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.externaldatasource_source_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.externaldatasource_source_id_seq OWNER TO postgres;

--
-- Name: externaldatasource_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.externaldatasource_source_id_seq OWNED BY public.externaldatasource.source_id;


--
-- Name: externalweatherdata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externalweatherdata (
    external_data_id integer NOT NULL,
    source_id integer NOT NULL,
    station_id integer,
    city_id integer,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    data_type character varying(50) NOT NULL,
    data_payload json NOT NULL,
    CONSTRAINT externalweatherdata_data_type_check CHECK (((data_type)::text = ANY ((ARRAY['Satellite Image'::character varying, 'Storm Alert'::character varying, 'Temperature Anomaly'::character varying, 'Earthquake'::character varying, 'Wildfire'::character varying, 'Flood'::character varying])::text[])))
);


ALTER TABLE public.externalweatherdata OWNER TO postgres;

--
-- Name: externalweatherdata_external_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.externalweatherdata_external_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.externalweatherdata_external_data_id_seq OWNER TO postgres;

--
-- Name: externalweatherdata_external_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.externalweatherdata_external_data_id_seq OWNED BY public.externalweatherdata.external_data_id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: healthrisklevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthrisklevel (
    parameter character varying(100) NOT NULL,
    level character varying(100) NOT NULL,
    recommendation text NOT NULL,
    CONSTRAINT healthrisklevel_level_check CHECK (((level)::text = ANY ((ARRAY['No Activity'::character varying, 'Low'::character varying, 'Moderate'::character varying, 'High'::character varying, 'Very High'::character varying, 'Extremely High'::character varying, 'Calm'::character varying, 'Mild Storm'::character varying, 'Moderate Storm'::character varying, 'Severe Storm'::character varying, 'Very Severe Storm'::character varying, 'Extremely Severe Storm'::character varying])::text[]))),
    CONSTRAINT healthrisklevel_parameter_check CHECK (((parameter)::text = ANY ((ARRAY['UV Index'::character varying, 'Pollen Concentration'::character varying, 'Geomagnetic Activity'::character varying, 'AQI'::character varying])::text[])))
);


ALTER TABLE public.healthrisklevel OWNER TO postgres;

--
-- Name: monthlyweatherstatistics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monthlyweatherstatistics (
    statistics_id integer NOT NULL,
    station_id integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    avg_day_temperature numeric(5,2) NOT NULL,
    avg_night_temperature numeric(5,2) NOT NULL,
    avg_humidity numeric(5,2) NOT NULL,
    avg_pressure numeric(6,2) NOT NULL,
    avg_wind_speed numeric(4,2) NOT NULL,
    total_precipitation numeric(5,2) NOT NULL,
    clear_days integer NOT NULL,
    rainy_days integer NOT NULL,
    cloudy_days integer NOT NULL,
    CONSTRAINT monthlyweatherstatistics_clear_days_check CHECK ((clear_days >= 0)),
    CONSTRAINT monthlyweatherstatistics_cloudy_days_check CHECK ((cloudy_days >= 0)),
    CONSTRAINT monthlyweatherstatistics_month_check CHECK (((month >= 1) AND (month <= 12))),
    CONSTRAINT monthlyweatherstatistics_rainy_days_check CHECK ((rainy_days >= 0)),
    CONSTRAINT monthlyweatherstatistics_year_check CHECK ((year >= 2000))
);


ALTER TABLE public.monthlyweatherstatistics OWNER TO postgres;

--
-- Name: monthlyweatherstatistics_statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monthlyweatherstatistics_statistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monthlyweatherstatistics_statistics_id_seq OWNER TO postgres;

--
-- Name: monthlyweatherstatistics_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monthlyweatherstatistics_statistics_id_seq OWNED BY public.monthlyweatherstatistics.statistics_id;


--
-- Name: naturaldisasteralert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.naturaldisasteralert (
    alert_id integer NOT NULL,
    station_id integer NOT NULL,
    alert_type character varying(50) NOT NULL,
    alert_level character varying(20) NOT NULL,
    alert_message text NOT NULL,
    alert_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT naturaldisasteralert_alert_level_check CHECK (((alert_level)::text = ANY ((ARRAY['Low'::character varying, 'Moderate'::character varying, 'High'::character varying, 'Very High'::character varying, 'Extremely High'::character varying])::text[]))),
    CONSTRAINT naturaldisasteralert_alert_type_check CHECK (((alert_type)::text = ANY ((ARRAY['Earthquake'::character varying, 'Volcanic Activity'::character varying, 'Tsunami'::character varying, 'Fire'::character varying, 'High Temperature'::character varying, 'Low Temperature'::character varying, 'Flood'::character varying, 'Avalanche'::character varying, 'Cyclone'::character varying, 'Tornado'::character varying, 'Severe Storm'::character varying])::text[])))
);


ALTER TABLE public.naturaldisasteralert OWNER TO postgres;

--
-- Name: naturaldisasteralert_alert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.naturaldisasteralert_alert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.naturaldisasteralert_alert_id_seq OWNER TO postgres;

--
-- Name: naturaldisasteralert_alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.naturaldisasteralert_alert_id_seq OWNED BY public.naturaldisasteralert.alert_id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    notification_id integer NOT NULL,
    user_id integer NOT NULL,
    type character varying(10) NOT NULL,
    message text NOT NULL,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT notification_type_check CHECK (((type)::text = ANY ((ARRAY['Email'::character varying, 'SMS'::character varying, 'Push'::character varying])::text[])))
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_notification_id_seq OWNER TO postgres;

--
-- Name: notification_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_notification_id_seq OWNED BY public.notification.notification_id;


--
-- Name: pollenmeasurement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pollenmeasurement (
    pollen_id integer NOT NULL,
    measurement_id integer NOT NULL,
    plant_name character varying(100) NOT NULL,
    pollen_concentration numeric(5,2) NOT NULL
);


ALTER TABLE public.pollenmeasurement OWNER TO postgres;

--
-- Name: pollenmeasurement_pollen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pollenmeasurement_pollen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pollenmeasurement_pollen_id_seq OWNER TO postgres;

--
-- Name: pollenmeasurement_pollen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pollenmeasurement_pollen_id_seq OWNED BY public.pollenmeasurement.pollen_id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    region_id integer NOT NULL,
    region_name character varying(100) NOT NULL,
    country_id integer NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: region_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.region_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.region_region_id_seq OWNER TO postgres;

--
-- Name: region_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.region_region_id_seq OWNED BY public.region.region_id;


--
-- Name: sensor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensor (
    sensor_id integer NOT NULL,
    station_id integer NOT NULL,
    type character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    last_calibration date,
    status character varying(20) NOT NULL,
    CONSTRAINT sensor_status_check CHECK (((status)::text = ANY ((ARRAY['Operational'::character varying, 'Faulty'::character varying, 'Maintenance Required'::character varying])::text[])))
);


ALTER TABLE public.sensor OWNER TO postgres;

--
-- Name: sensor_sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_sensor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sensor_sensor_id_seq OWNER TO postgres;

--
-- Name: sensor_sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_sensor_id_seq OWNED BY public.sensor.sensor_id;


--
-- Name: sensorcalibrationhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensorcalibrationhistory (
    calibration_id integer NOT NULL,
    sensor_id integer NOT NULL,
    calibration_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    technician_id integer NOT NULL,
    calibration_result character varying(40) NOT NULL,
    notes text NOT NULL,
    CONSTRAINT sensorcalibrationhistory_calibration_result_check CHECK (((calibration_result)::text = ANY ((ARRAY['Successful'::character varying, 'Failed'::character varying, 'Requires Further Testing'::character varying])::text[])))
);


ALTER TABLE public.sensorcalibrationhistory OWNER TO postgres;

--
-- Name: sensorcalibrationhistory_calibration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensorcalibrationhistory_calibration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sensorcalibrationhistory_calibration_id_seq OWNER TO postgres;

--
-- Name: sensorcalibrationhistory_calibration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensorcalibrationhistory_calibration_id_seq OWNED BY public.sensorcalibrationhistory.calibration_id;


--
-- Name: userfavoritelocations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userfavoritelocations (
    favorite_id integer NOT NULL,
    user_id integer NOT NULL,
    city_id integer,
    station_id integer,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.userfavoritelocations OWNER TO postgres;

--
-- Name: userfavoritelocations_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userfavoritelocations_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userfavoritelocations_favorite_id_seq OWNER TO postgres;

--
-- Name: userfavoritelocations_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userfavoritelocations_favorite_id_seq OWNED BY public.userfavoritelocations.favorite_id;


--
-- Name: userhistoryrecentviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userhistoryrecentviews (
    view_id integer NOT NULL,
    user_id integer NOT NULL,
    city_id integer NOT NULL,
    viewed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.userhistoryrecentviews OWNER TO postgres;

--
-- Name: userhistoryrecentviews_view_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userhistoryrecentviews_view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userhistoryrecentviews_view_id_seq OWNER TO postgres;

--
-- Name: userhistoryrecentviews_view_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userhistoryrecentviews_view_id_seq OWNED BY public.userhistoryrecentviews.view_id;


--
-- Name: userhomelocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userhomelocation (
    favorite_id integer NOT NULL,
    user_id integer NOT NULL,
    city_id integer,
    station_id integer,
    latitude numeric(8,6),
    longitude numeric(9,6),
    CONSTRAINT userhomelocation_check CHECK ((((city_id IS NOT NULL) AND (station_id IS NULL) AND (latitude IS NULL) AND (longitude IS NULL)) OR ((city_id IS NULL) AND (station_id IS NOT NULL) AND (latitude IS NULL) AND (longitude IS NULL)) OR ((city_id IS NULL) AND (station_id IS NULL) AND (latitude IS NOT NULL) AND (longitude IS NOT NULL))))
);


ALTER TABLE public.userhomelocation OWNER TO postgres;

--
-- Name: userhomelocation_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userhomelocation_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userhomelocation_favorite_id_seq OWNER TO postgres;

--
-- Name: userhomelocation_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userhomelocation_favorite_id_seq OWNED BY public.userhomelocation.favorite_id;


--
-- Name: usernotificationpreferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usernotificationpreferences (
    preference_id integer NOT NULL,
    user_id integer NOT NULL,
    weather_characteristic character varying(50) NOT NULL,
    notification_method character varying(10) NOT NULL,
    threshold_level character varying(20) NOT NULL,
    CONSTRAINT usernotificationpreferences_notification_method_check CHECK (((notification_method)::text = ANY ((ARRAY['Email'::character varying, 'SMS'::character varying, 'Push'::character varying])::text[]))),
    CONSTRAINT usernotificationpreferences_weather_characteristic_check CHECK (((weather_characteristic)::text = ANY ((ARRAY['Temperature'::character varying, 'Humidity'::character varying, 'Pressure'::character varying, 'Wind Speed'::character varying, 'Precipitation'::character varying, 'UV Index'::character varying, 'Pollen Concentration'::character varying, 'Geomagnetic Activity'::character varying, 'AQI'::character varying])::text[])))
);


ALTER TABLE public.usernotificationpreferences OWNER TO postgres;

--
-- Name: usernotificationpreferences_preference_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usernotificationpreferences_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usernotificationpreferences_preference_id_seq OWNER TO postgres;

--
-- Name: usernotificationpreferences_preference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usernotificationpreferences_preference_id_seq OWNED BY public.usernotificationpreferences.preference_id;


--
-- Name: userpollenpreferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userpollenpreferences (
    preference_id integer NOT NULL,
    user_id integer NOT NULL,
    plant_name character varying(100) NOT NULL,
    notification_threshold numeric(5,2) NOT NULL,
    notify_on_decrease boolean NOT NULL
);


ALTER TABLE public.userpollenpreferences OWNER TO postgres;

--
-- Name: userpollenpreferences_preference_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userpollenpreferences_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userpollenpreferences_preference_id_seq OWNER TO postgres;

--
-- Name: userpollenpreferences_preference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userpollenpreferences_preference_id_seq OWNED BY public.userpollenpreferences.preference_id;


--
-- Name: userunitssettings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userunitssettings (
    settings_id integer NOT NULL,
    user_id integer NOT NULL,
    temperature_unit character varying(40) NOT NULL,
    precipitation_unit character varying(20) NOT NULL,
    wind_speed_unit character varying(50) NOT NULL,
    pressure_unit character varying(20) NOT NULL,
    visibility_unit character varying(5) NOT NULL,
    update_frequency_in_minutes integer NOT NULL,
    CONSTRAINT userunitssettings_precipitation_unit_check CHECK (((precipitation_unit)::text = ANY ((ARRAY['mm (rain), cm (snow)'::character varying, 'inches'::character varying])::text[]))),
    CONSTRAINT userunitssettings_pressure_unit_check CHECK (((pressure_unit)::text = ANY ((ARRAY['mm_of_mercury'::character varying, 'inches_of_mercury'::character varying, 'mbar'::character varying, 'gPa'::character varying])::text[]))),
    CONSTRAINT userunitssettings_temperature_unit_check CHECK (((temperature_unit)::text = ANY ((ARRAY['Celsius'::character varying, 'Fahrenheit'::character varying])::text[]))),
    CONSTRAINT userunitssettings_update_frequency_in_minutes_check CHECK ((update_frequency_in_minutes > 0)),
    CONSTRAINT userunitssettings_visibility_unit_check CHECK (((visibility_unit)::text = ANY ((ARRAY['km'::character varying, 'miles'::character varying])::text[]))),
    CONSTRAINT userunitssettings_wind_speed_unit_check CHECK (((wind_speed_unit)::text = ANY ((ARRAY['m/s'::character varying, 'km/h'::character varying, 'mph'::character varying, 'knots'::character varying, 'Beaufort points'::character varying])::text[])))
);


ALTER TABLE public.userunitssettings OWNER TO postgres;

--
-- Name: userunitssettings_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userunitssettings_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userunitssettings_settings_id_seq OWNER TO postgres;

--
-- Name: userunitssettings_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userunitssettings_settings_id_seq OWNED BY public.userunitssettings.settings_id;


--
-- Name: userweatherquestionnaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userweatherquestionnaire (
    survey_id integer NOT NULL,
    user_id integer NOT NULL,
    city_id integer NOT NULL,
    survey_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    condition character varying(20) NOT NULL,
    CONSTRAINT userweatherquestionnaire_condition_check CHECK (((condition)::text = ANY ((ARRAY['Rain'::character varying, 'No Rain'::character varying, 'Snow'::character varying, 'No Snow'::character varying, 'Fog'::character varying, 'No Fog'::character varying, 'Clear'::character varying, 'Storm'::character varying])::text[])))
);


ALTER TABLE public.userweatherquestionnaire OWNER TO postgres;

--
-- Name: userweatherquestionnaire_survey_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userweatherquestionnaire_survey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userweatherquestionnaire_survey_id_seq OWNER TO postgres;

--
-- Name: userweatherquestionnaire_survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userweatherquestionnaire_survey_id_seq OWNED BY public.userweatherquestionnaire.survey_id;


--
-- Name: weathermeasurement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weathermeasurement (
    measurement_id integer NOT NULL,
    station_id integer NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    temperature numeric(4,2) NOT NULL,
    dew_point_temperature numeric(4,2) NOT NULL,
    humidity numeric(3,0) NOT NULL,
    pressure numeric(6,2) NOT NULL,
    wind_speed numeric(6,2) NOT NULL,
    wind_direction character varying(2) NOT NULL,
    wind_direction_degrees numeric(3,0) NOT NULL,
    wind_gusts_speed numeric(3,0) NOT NULL,
    precipitation_mm numeric(8,0) NOT NULL,
    precipitation_type character varying(10) NOT NULL,
    uv_index numeric(2,0) NOT NULL,
    visibility numeric(6,0) NOT NULL,
    geomagnetic_activity numeric(2,0) NOT NULL,
    sunrise_time time without time zone NOT NULL,
    sunset_time time without time zone NOT NULL,
    aqi numeric(4,0) NOT NULL,
    moon_phase character varying(20) NOT NULL,
    CONSTRAINT weathermeasurement_moon_phase_check CHECK (((moon_phase)::text = ANY ((ARRAY['Full Moon'::character varying, 'New Moon'::character varying, 'First Quarter'::character varying, 'Last Quarter'::character varying, 'Growing Sickle'::character varying, 'Growing Moon'::character varying, 'Waning Moon'::character varying, 'Waning Sickle'::character varying])::text[]))),
    CONSTRAINT weathermeasurement_precipitation_type_check CHECK (((precipitation_type)::text = ANY ((ARRAY['Rain'::character varying, 'Snow'::character varying, 'Hail'::character varying, 'Sleet'::character varying, 'None'::character varying])::text[]))),
    CONSTRAINT weathermeasurement_wind_direction_check CHECK (((wind_direction)::text = ANY ((ARRAY['N'::character varying, 'S'::character varying, 'W'::character varying, 'E'::character varying, 'NW'::character varying, 'SW'::character varying, 'SE'::character varying, 'NE'::character varying])::text[])))
);


ALTER TABLE public.weathermeasurement OWNER TO postgres;

--
-- Name: weathermeasurement_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weathermeasurement_measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weathermeasurement_measurement_id_seq OWNER TO postgres;

--
-- Name: weathermeasurement_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weathermeasurement_measurement_id_seq OWNED BY public.weathermeasurement.measurement_id;


--
-- Name: weatherstation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weatherstation (
    station_id integer NOT NULL,
    city_id integer NOT NULL,
    latitude numeric(8,6) NOT NULL,
    longitude numeric(9,6) NOT NULL,
    altitude_above_sea_level_in_metres numeric(7,2) NOT NULL,
    manufacturer character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    release_date date NOT NULL,
    commissioning_date date NOT NULL,
    last_maintenance date,
    status character varying(20) NOT NULL,
    CONSTRAINT weatherstation_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Inactive'::character varying, 'Under Maintenance'::character varying])::text[])))
);


ALTER TABLE public.weatherstation OWNER TO postgres;

--
-- Name: weatherstation_station_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weatherstation_station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weatherstation_station_id_seq OWNER TO postgres;

--
-- Name: weatherstation_station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weatherstation_station_id_seq OWNED BY public.weatherstation.station_id;


--
-- Name: weatherstationmaintenance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weatherstationmaintenance (
    maintenance_id integer NOT NULL,
    station_id integer NOT NULL,
    maintenance_date date NOT NULL,
    technician_id integer NOT NULL,
    description text NOT NULL,
    status_after character varying(20) NOT NULL,
    CONSTRAINT weatherstationmaintenance_status_after_check CHECK (((status_after)::text = ANY ((ARRAY['Operational'::character varying, 'Requires Repair'::character varying, 'Decommissioned'::character varying])::text[])))
);


ALTER TABLE public.weatherstationmaintenance OWNER TO postgres;

--
-- Name: weatherstationmaintenance_maintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weatherstationmaintenance_maintenance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weatherstationmaintenance_maintenance_id_seq OWNER TO postgres;

--
-- Name: weatherstationmaintenance_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weatherstationmaintenance_maintenance_id_seq OWNED BY public.weatherstationmaintenance.maintenance_id;


--
-- Name: User user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN user_id SET DEFAULT nextval('public."User_user_id_seq"'::regclass);


--
-- Name: city city_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city ALTER COLUMN city_id SET DEFAULT nextval('public.city_city_id_seq'::regclass);


--
-- Name: country country_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country ALTER COLUMN country_id SET DEFAULT nextval('public.country_country_id_seq'::regclass);


--
-- Name: employee employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN employee_id SET DEFAULT nextval('public.employee_employee_id_seq'::regclass);


--
-- Name: externaldatasource source_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externaldatasource ALTER COLUMN source_id SET DEFAULT nextval('public.externaldatasource_source_id_seq'::regclass);


--
-- Name: externalweatherdata external_data_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externalweatherdata ALTER COLUMN external_data_id SET DEFAULT nextval('public.externalweatherdata_external_data_id_seq'::regclass);


--
-- Name: monthlyweatherstatistics statistics_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthlyweatherstatistics ALTER COLUMN statistics_id SET DEFAULT nextval('public.monthlyweatherstatistics_statistics_id_seq'::regclass);


--
-- Name: naturaldisasteralert alert_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naturaldisasteralert ALTER COLUMN alert_id SET DEFAULT nextval('public.naturaldisasteralert_alert_id_seq'::regclass);


--
-- Name: notification notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification ALTER COLUMN notification_id SET DEFAULT nextval('public.notification_notification_id_seq'::regclass);


--
-- Name: pollenmeasurement pollen_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pollenmeasurement ALTER COLUMN pollen_id SET DEFAULT nextval('public.pollenmeasurement_pollen_id_seq'::regclass);


--
-- Name: region region_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region ALTER COLUMN region_id SET DEFAULT nextval('public.region_region_id_seq'::regclass);


--
-- Name: sensor sensor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor ALTER COLUMN sensor_id SET DEFAULT nextval('public.sensor_sensor_id_seq'::regclass);


--
-- Name: sensorcalibrationhistory calibration_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensorcalibrationhistory ALTER COLUMN calibration_id SET DEFAULT nextval('public.sensorcalibrationhistory_calibration_id_seq'::regclass);


--
-- Name: userfavoritelocations favorite_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations ALTER COLUMN favorite_id SET DEFAULT nextval('public.userfavoritelocations_favorite_id_seq'::regclass);


--
-- Name: userhistoryrecentviews view_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhistoryrecentviews ALTER COLUMN view_id SET DEFAULT nextval('public.userhistoryrecentviews_view_id_seq'::regclass);


--
-- Name: userhomelocation favorite_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhomelocation ALTER COLUMN favorite_id SET DEFAULT nextval('public.userhomelocation_favorite_id_seq'::regclass);


--
-- Name: usernotificationpreferences preference_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usernotificationpreferences ALTER COLUMN preference_id SET DEFAULT nextval('public.usernotificationpreferences_preference_id_seq'::regclass);


--
-- Name: userpollenpreferences preference_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userpollenpreferences ALTER COLUMN preference_id SET DEFAULT nextval('public.userpollenpreferences_preference_id_seq'::regclass);


--
-- Name: userunitssettings settings_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userunitssettings ALTER COLUMN settings_id SET DEFAULT nextval('public.userunitssettings_settings_id_seq'::regclass);


--
-- Name: userweatherquestionnaire survey_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userweatherquestionnaire ALTER COLUMN survey_id SET DEFAULT nextval('public.userweatherquestionnaire_survey_id_seq'::regclass);


--
-- Name: weathermeasurement measurement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weathermeasurement ALTER COLUMN measurement_id SET DEFAULT nextval('public.weathermeasurement_measurement_id_seq'::regclass);


--
-- Name: weatherstation station_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstation ALTER COLUMN station_id SET DEFAULT nextval('public.weatherstation_station_id_seq'::regclass);


--
-- Name: weatherstationmaintenance maintenance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstationmaintenance ALTER COLUMN maintenance_id SET DEFAULT nextval('public.weatherstationmaintenance_maintenance_id_seq'::regclass);


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (user_id, first_name, last_name, email, phone, password_hash) FROM stdin;
\.


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.city (city_id, name, region_id, latitude, longitude) FROM stdin;
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.country (country_id, country_name) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (employee_id, first_name, last_name, patronymic, role, email, phone) FROM stdin;
\.


--
-- Data for Name: externaldatasource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externaldatasource (source_id, name, api_url, last_fetched) FROM stdin;
\.


--
-- Data for Name: externalweatherdata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externalweatherdata (external_data_id, source_id, station_id, city_id, "timestamp", data_type, data_payload) FROM stdin;
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	Create Geographical Entities	SQL	V1__Create_Geographical_Entities.sql	-1396927214	postgres	2025-06-11 14:08:02.872811	72	t
2	2	Create Weather Entities	SQL	V2__Create_Weather_Entities.sql	-1814839150	postgres	2025-06-11 14:08:03.018801	125	t
3	3	Create User Entities	SQL	V3__Create_User_Entities.sql	129533400	postgres	2025-06-11 14:08:03.279866	93	t
4	4	Create Notification Entities	SQL	V4__Create_Notification_Entities.sql	-1776349073	postgres	2025-06-11 14:08:03.492508	68	t
5	5	Create External Data Entities	SQL	V5__Create_External_Data_Entities.sql	1582693863	postgres	2025-06-11 14:08:03.706994	42	t
6	6	Create Maintenance Entities	SQL	V6__Create_Maintenance_Entities.sql	996382829	postgres	2025-06-11 14:08:03.76534	56	t
7	7	Create Survey Entities	SQL	V7__Create_Survey_Entities.sql	-842429805	postgres	2025-06-11 14:08:03.838241	66	t
\.


--
-- Data for Name: healthrisklevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.healthrisklevel (parameter, level, recommendation) FROM stdin;
\.


--
-- Data for Name: monthlyweatherstatistics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monthlyweatherstatistics (statistics_id, station_id, month, year, avg_day_temperature, avg_night_temperature, avg_humidity, avg_pressure, avg_wind_speed, total_precipitation, clear_days, rainy_days, cloudy_days) FROM stdin;
\.


--
-- Data for Name: naturaldisasteralert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.naturaldisasteralert (alert_id, station_id, alert_type, alert_level, alert_message, alert_time) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (notification_id, user_id, type, message, sent_at) FROM stdin;
\.


--
-- Data for Name: pollenmeasurement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pollenmeasurement (pollen_id, measurement_id, plant_name, pollen_concentration) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (region_id, region_name, country_id) FROM stdin;
\.


--
-- Data for Name: sensor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sensor (sensor_id, station_id, type, model, last_calibration, status) FROM stdin;
\.


--
-- Data for Name: sensorcalibrationhistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sensorcalibrationhistory (calibration_id, sensor_id, calibration_timestamp, technician_id, calibration_result, notes) FROM stdin;
\.


--
-- Data for Name: userfavoritelocations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userfavoritelocations (favorite_id, user_id, city_id, station_id, added_at) FROM stdin;
\.


--
-- Data for Name: userhistoryrecentviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userhistoryrecentviews (view_id, user_id, city_id, viewed_at) FROM stdin;
\.


--
-- Data for Name: userhomelocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userhomelocation (favorite_id, user_id, city_id, station_id, latitude, longitude) FROM stdin;
\.


--
-- Data for Name: usernotificationpreferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usernotificationpreferences (preference_id, user_id, weather_characteristic, notification_method, threshold_level) FROM stdin;
\.


--
-- Data for Name: userpollenpreferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userpollenpreferences (preference_id, user_id, plant_name, notification_threshold, notify_on_decrease) FROM stdin;
\.


--
-- Data for Name: userunitssettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userunitssettings (settings_id, user_id, temperature_unit, precipitation_unit, wind_speed_unit, pressure_unit, visibility_unit, update_frequency_in_minutes) FROM stdin;
\.


--
-- Data for Name: userweatherquestionnaire; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userweatherquestionnaire (survey_id, user_id, city_id, survey_time, condition) FROM stdin;
\.


--
-- Data for Name: weathermeasurement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weathermeasurement (measurement_id, station_id, "timestamp", temperature, dew_point_temperature, humidity, pressure, wind_speed, wind_direction, wind_direction_degrees, wind_gusts_speed, precipitation_mm, precipitation_type, uv_index, visibility, geomagnetic_activity, sunrise_time, sunset_time, aqi, moon_phase) FROM stdin;
\.


--
-- Data for Name: weatherstation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weatherstation (station_id, city_id, latitude, longitude, altitude_above_sea_level_in_metres, manufacturer, model, release_date, commissioning_date, last_maintenance, status) FROM stdin;
\.


--
-- Data for Name: weatherstationmaintenance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weatherstationmaintenance (maintenance_id, station_id, maintenance_date, technician_id, description, status_after) FROM stdin;
\.


--
-- Name: User_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_user_id_seq"', 1, false);


--
-- Name: city_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.city_city_id_seq', 1, false);


--
-- Name: country_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_country_id_seq', 243, true);


--
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_employee_id_seq', 1, false);


--
-- Name: externaldatasource_source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.externaldatasource_source_id_seq', 1, false);


--
-- Name: externalweatherdata_external_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.externalweatherdata_external_data_id_seq', 1, false);


--
-- Name: monthlyweatherstatistics_statistics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monthlyweatherstatistics_statistics_id_seq', 1, false);


--
-- Name: naturaldisasteralert_alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.naturaldisasteralert_alert_id_seq', 1, false);


--
-- Name: notification_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_notification_id_seq', 1, false);


--
-- Name: pollenmeasurement_pollen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pollenmeasurement_pollen_id_seq', 1, false);


--
-- Name: region_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.region_region_id_seq', 1, false);


--
-- Name: sensor_sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_sensor_id_seq', 1, false);


--
-- Name: sensorcalibrationhistory_calibration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensorcalibrationhistory_calibration_id_seq', 1, false);


--
-- Name: userfavoritelocations_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userfavoritelocations_favorite_id_seq', 1, false);


--
-- Name: userhistoryrecentviews_view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userhistoryrecentviews_view_id_seq', 1, false);


--
-- Name: userhomelocation_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userhomelocation_favorite_id_seq', 1, false);


--
-- Name: usernotificationpreferences_preference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usernotificationpreferences_preference_id_seq', 1, false);


--
-- Name: userpollenpreferences_preference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userpollenpreferences_preference_id_seq', 1, false);


--
-- Name: userunitssettings_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userunitssettings_settings_id_seq', 1, false);


--
-- Name: userweatherquestionnaire_survey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userweatherquestionnaire_survey_id_seq', 1, false);


--
-- Name: weathermeasurement_measurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weathermeasurement_measurement_id_seq', 1, false);


--
-- Name: weatherstation_station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weatherstation_station_id_seq', 1, false);


--
-- Name: weatherstationmaintenance_maintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weatherstationmaintenance_maintenance_id_seq', 1, false);


--
-- Name: User User_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);


--
-- Name: city city_name_region_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_name_region_id_key UNIQUE (name, region_id);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);


--
-- Name: country country_country_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_country_name_key UNIQUE (country_name);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- Name: employee employee_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_email_key UNIQUE (email);


--
-- Name: employee employee_first_name_last_name_patronymic_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_first_name_last_name_patronymic_email_key UNIQUE (first_name, last_name, patronymic, email);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: externaldatasource externaldatasource_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externaldatasource
    ADD CONSTRAINT externaldatasource_name_key UNIQUE (name);


--
-- Name: externaldatasource externaldatasource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externaldatasource
    ADD CONSTRAINT externaldatasource_pkey PRIMARY KEY (source_id);


--
-- Name: externalweatherdata externalweatherdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externalweatherdata
    ADD CONSTRAINT externalweatherdata_pkey PRIMARY KEY (external_data_id);


--
-- Name: externalweatherdata externalweatherdata_source_id_station_id_city_id_timestamp_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externalweatherdata
    ADD CONSTRAINT externalweatherdata_source_id_station_id_city_id_timestamp_key UNIQUE (source_id, station_id, city_id, "timestamp");


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: healthrisklevel healthrisklevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthrisklevel
    ADD CONSTRAINT healthrisklevel_pkey PRIMARY KEY (parameter, level);


--
-- Name: monthlyweatherstatistics monthlyweatherstatistics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthlyweatherstatistics
    ADD CONSTRAINT monthlyweatherstatistics_pkey PRIMARY KEY (statistics_id);


--
-- Name: monthlyweatherstatistics monthlyweatherstatistics_station_id_month_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthlyweatherstatistics
    ADD CONSTRAINT monthlyweatherstatistics_station_id_month_year_key UNIQUE (station_id, month, year);


--
-- Name: naturaldisasteralert naturaldisasteralert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naturaldisasteralert
    ADD CONSTRAINT naturaldisasteralert_pkey PRIMARY KEY (alert_id);


--
-- Name: naturaldisasteralert naturaldisasteralert_station_id_alert_type_alert_time_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naturaldisasteralert
    ADD CONSTRAINT naturaldisasteralert_station_id_alert_type_alert_time_key UNIQUE (station_id, alert_type, alert_time);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (notification_id);


--
-- Name: pollenmeasurement pollenmeasurement_measurement_id_plant_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pollenmeasurement
    ADD CONSTRAINT pollenmeasurement_measurement_id_plant_name_key UNIQUE (measurement_id, plant_name);


--
-- Name: pollenmeasurement pollenmeasurement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pollenmeasurement
    ADD CONSTRAINT pollenmeasurement_pkey PRIMARY KEY (pollen_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: region region_region_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_region_name_key UNIQUE (region_name);


--
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (sensor_id);


--
-- Name: sensor sensor_station_id_type_model_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_station_id_type_model_key UNIQUE (station_id, type, model);


--
-- Name: sensorcalibrationhistory sensorcalibrationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensorcalibrationhistory
    ADD CONSTRAINT sensorcalibrationhistory_pkey PRIMARY KEY (calibration_id);


--
-- Name: userfavoritelocations userfavoritelocations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations
    ADD CONSTRAINT userfavoritelocations_pkey PRIMARY KEY (favorite_id);


--
-- Name: userfavoritelocations userfavoritelocations_user_id_city_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations
    ADD CONSTRAINT userfavoritelocations_user_id_city_id_key UNIQUE (user_id, city_id);


--
-- Name: userfavoritelocations userfavoritelocations_user_id_station_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations
    ADD CONSTRAINT userfavoritelocations_user_id_station_id_key UNIQUE (user_id, station_id);


--
-- Name: userhistoryrecentviews userhistoryrecentviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhistoryrecentviews
    ADD CONSTRAINT userhistoryrecentviews_pkey PRIMARY KEY (view_id);


--
-- Name: userhistoryrecentviews userhistoryrecentviews_user_id_city_id_viewed_at_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhistoryrecentviews
    ADD CONSTRAINT userhistoryrecentviews_user_id_city_id_viewed_at_key UNIQUE (user_id, city_id, viewed_at);


--
-- Name: userhomelocation userhomelocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhomelocation
    ADD CONSTRAINT userhomelocation_pkey PRIMARY KEY (favorite_id);


--
-- Name: userhomelocation userhomelocation_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhomelocation
    ADD CONSTRAINT userhomelocation_user_id_key UNIQUE (user_id);


--
-- Name: usernotificationpreferences usernotificationpreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usernotificationpreferences
    ADD CONSTRAINT usernotificationpreferences_pkey PRIMARY KEY (preference_id);


--
-- Name: usernotificationpreferences usernotificationpreferences_user_id_weather_characteristic__key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usernotificationpreferences
    ADD CONSTRAINT usernotificationpreferences_user_id_weather_characteristic__key UNIQUE (user_id, weather_characteristic, notification_method);


--
-- Name: userpollenpreferences userpollenpreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userpollenpreferences
    ADD CONSTRAINT userpollenpreferences_pkey PRIMARY KEY (preference_id);


--
-- Name: userpollenpreferences userpollenpreferences_user_id_plant_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userpollenpreferences
    ADD CONSTRAINT userpollenpreferences_user_id_plant_name_key UNIQUE (user_id, plant_name);


--
-- Name: userunitssettings userunitssettings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userunitssettings
    ADD CONSTRAINT userunitssettings_pkey PRIMARY KEY (settings_id);


--
-- Name: userunitssettings userunitssettings_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userunitssettings
    ADD CONSTRAINT userunitssettings_user_id_key UNIQUE (user_id);


--
-- Name: userweatherquestionnaire userweatherquestionnaire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userweatherquestionnaire
    ADD CONSTRAINT userweatherquestionnaire_pkey PRIMARY KEY (survey_id);


--
-- Name: userweatherquestionnaire userweatherquestionnaire_user_id_city_id_survey_time_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userweatherquestionnaire
    ADD CONSTRAINT userweatherquestionnaire_user_id_city_id_survey_time_key UNIQUE (user_id, city_id, survey_time);


--
-- Name: weathermeasurement weathermeasurement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weathermeasurement
    ADD CONSTRAINT weathermeasurement_pkey PRIMARY KEY (measurement_id);


--
-- Name: weathermeasurement weathermeasurement_station_id_timestamp_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weathermeasurement
    ADD CONSTRAINT weathermeasurement_station_id_timestamp_key UNIQUE (station_id, "timestamp");


--
-- Name: weatherstation weatherstation_city_id_latitude_longitude_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstation
    ADD CONSTRAINT weatherstation_city_id_latitude_longitude_key UNIQUE (city_id, latitude, longitude);


--
-- Name: weatherstation weatherstation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstation
    ADD CONSTRAINT weatherstation_pkey PRIMARY KEY (station_id);


--
-- Name: weatherstationmaintenance weatherstationmaintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstationmaintenance
    ADD CONSTRAINT weatherstationmaintenance_pkey PRIMARY KEY (maintenance_id);


--
-- Name: weatherstationmaintenance weatherstationmaintenance_station_id_maintenance_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstationmaintenance
    ADD CONSTRAINT weatherstationmaintenance_station_id_maintenance_date_key UNIQUE (station_id, maintenance_date);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: city city_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.region(region_id);


--
-- Name: externalweatherdata externalweatherdata_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externalweatherdata
    ADD CONSTRAINT externalweatherdata_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: externalweatherdata externalweatherdata_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externalweatherdata
    ADD CONSTRAINT externalweatherdata_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.externaldatasource(source_id);


--
-- Name: externalweatherdata externalweatherdata_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externalweatherdata
    ADD CONSTRAINT externalweatherdata_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: monthlyweatherstatistics monthlyweatherstatistics_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthlyweatherstatistics
    ADD CONSTRAINT monthlyweatherstatistics_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: naturaldisasteralert naturaldisasteralert_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naturaldisasteralert
    ADD CONSTRAINT naturaldisasteralert_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: notification notification_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: pollenmeasurement pollenmeasurement_measurement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pollenmeasurement
    ADD CONSTRAINT pollenmeasurement_measurement_id_fkey FOREIGN KEY (measurement_id) REFERENCES public.weathermeasurement(measurement_id);


--
-- Name: region region_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- Name: sensor sensor_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: sensorcalibrationhistory sensorcalibrationhistory_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensorcalibrationhistory
    ADD CONSTRAINT sensorcalibrationhistory_sensor_id_fkey FOREIGN KEY (sensor_id) REFERENCES public.sensor(sensor_id);


--
-- Name: sensorcalibrationhistory sensorcalibrationhistory_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensorcalibrationhistory
    ADD CONSTRAINT sensorcalibrationhistory_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.employee(employee_id);


--
-- Name: userfavoritelocations userfavoritelocations_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations
    ADD CONSTRAINT userfavoritelocations_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: userfavoritelocations userfavoritelocations_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations
    ADD CONSTRAINT userfavoritelocations_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: userfavoritelocations userfavoritelocations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userfavoritelocations
    ADD CONSTRAINT userfavoritelocations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: userhistoryrecentviews userhistoryrecentviews_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhistoryrecentviews
    ADD CONSTRAINT userhistoryrecentviews_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: userhistoryrecentviews userhistoryrecentviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhistoryrecentviews
    ADD CONSTRAINT userhistoryrecentviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: userhomelocation userhomelocation_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhomelocation
    ADD CONSTRAINT userhomelocation_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: userhomelocation userhomelocation_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhomelocation
    ADD CONSTRAINT userhomelocation_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: userhomelocation userhomelocation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userhomelocation
    ADD CONSTRAINT userhomelocation_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: usernotificationpreferences usernotificationpreferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usernotificationpreferences
    ADD CONSTRAINT usernotificationpreferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: userpollenpreferences userpollenpreferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userpollenpreferences
    ADD CONSTRAINT userpollenpreferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: userunitssettings userunitssettings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userunitssettings
    ADD CONSTRAINT userunitssettings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: userweatherquestionnaire userweatherquestionnaire_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userweatherquestionnaire
    ADD CONSTRAINT userweatherquestionnaire_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: userweatherquestionnaire userweatherquestionnaire_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userweatherquestionnaire
    ADD CONSTRAINT userweatherquestionnaire_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- Name: weathermeasurement weathermeasurement_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weathermeasurement
    ADD CONSTRAINT weathermeasurement_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: weatherstation weatherstation_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstation
    ADD CONSTRAINT weatherstation_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: weatherstationmaintenance weatherstationmaintenance_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstationmaintenance
    ADD CONSTRAINT weatherstationmaintenance_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.weatherstation(station_id);


--
-- Name: weatherstationmaintenance weatherstationmaintenance_technician_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weatherstationmaintenance
    ADD CONSTRAINT weatherstationmaintenance_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES public.employee(employee_id);


--
-- PostgreSQL database dump complete
--

