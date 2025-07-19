#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" << EOSQL
    CREATE ROLE analytic NOLOGIN;
    
    GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO analytic;
    GRANT USAGE ON SCHEMA public TO analytic;
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO analytic;
    GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO analytic;

    DO \$\$DECLARE
        analyst_name TEXT;
        analysts_list TEXT;
    BEGIN
        SELECT current_setting('analyst.names', TRUE) INTO analysts_list;
        
        IF analysts_list IS NOT NULL THEN
            FOREACH analyst_name IN ARRAY string_to_array(analysts_list, ',') LOOP
                EXECUTE format('CREATE USER %I WITH PASSWORD %L', analyst_name, analyst_name || '_123');
                EXECUTE format('GRANT analytic TO %I', analyst_name);
            END LOOP;
        ELSE
            RAISE NOTICE 'No analysts configured in settings';
        END IF;
    END \$\$;
EOSQL