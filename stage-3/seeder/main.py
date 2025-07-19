import psycopg2
from psycopg2 import sql
from urllib.parse import urlparse
import time
from concurrent.futures import ThreadPoolExecutor
import os
from base import DatabaseSeeder
from versions import VERSIONS

def main():
    version = os.getenv("MIGRATION_VERSION", "1")
    print(f">> Running seeder version: {version}")

    seeder = DatabaseSeeder()
    try:
        if version in VERSIONS:
            VERSIONS[version](seeder)
            seeder.commit()
            print(">> Seeding complete.")
        else:
            print(f"[ERROR] Unknown seeding version: {version}")
    except Exception as e:
        print(f"[ERROR] Seeding failed: {e}")
        seeder.rollback()
    finally:
        seeder.close()

if __name__ == "__main__":
    main()