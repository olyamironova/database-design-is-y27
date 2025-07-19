import psycopg2
from urllib.parse import urlparse
import time
import os
from seeder.base import DatabaseSeeder
from prometheus.metrics import QUERY_TIME, QUERY_COUNTER, QUERY_DURATION_HISTOGRAM, QUERY_ERRORS
from queries.weather_queries import WeatherQueries

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "haproxy"),
    "port": int(os.getenv("DB_PORT", 5432)),
    "dbname": os.getenv("DB_NAME", "weather"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
}

def run_query(query_name, query_sql):
    start = time.time()
    try:
        duration = time.time() - start
        QUERY_TIME.labels(query_name=query_name, optimized='no').observe(duration)
        QUERY_DURATION_HISTOGRAM.labels(query_name=query_name, optimized='no').observe(duration)
        QUERY_COUNTER.labels(query_name=query_name, optimized='no').inc()
    except Exception as e:
        QUERY_ERRORS.labels(query_name=query_name, optimized='no').inc()

def execute_complex_queries(seeder: DatabaseSeeder, count: int = 5):
    """Выполняет сложные аналитические запросы"""
    print(">> Executing complex analytical queries...")
    queries = WeatherQueries.get_complex_queries()
    
    for i in range(min(count, len(queries))):
        query = queries[i]
        print(f"\nExecuting query: {query['name']}")
        print(f"Description: {query['description']}")
        
        start_time = time.time()
        try:
            seeder.cur.execute(query["query"])
            results = seeder.cur.fetchmany(20)
            duration = time.time() - start_time
            
            print(f"Execution time: {duration:.2f}s")
            print("Sample results:")
            for row in results:
                print(row)
        except Exception as e:
            print(f"Query failed: {e}")
            seeder.rollback()

def main():
    print(">> Skipping seeding; running metrics/queries only.")

    seeder = DatabaseSeeder()
    try:
        if os.getenv("EXECUTE_COMPLEX_QUERIES", "false").lower() == "true":
            execute_complex_queries(seeder)

        seeder.commit()
        print(">> Queries execution complete.")
    except Exception as e:
        print(f"[ERROR] Execution failed: {e}")
        seeder.rollback()
    finally:
        seeder.close()

if __name__ == "__main__":
    main()
