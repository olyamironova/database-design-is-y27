import os
import psycopg2
import subprocess
import sys
from datetime import datetime
from psycopg2 import sql
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    return psycopg2.connect(
        host=os.environ.get("DB_HOST", "localhost"),
        port=os.environ.get("DB_PORT", 5432),
        dbname=os.environ.get("DB_NAME", "postgres"),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", "postgres")
    )

def save_schema(version, suffix):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE';
    """)
    tables = sorted([row[0] for row in cursor.fetchall()])

    schema = {}

    for table in tables:
        try:
            cursor.execute("""
                SELECT column_name, data_type, is_nullable, column_default
                FROM information_schema.columns
                WHERE table_name = %s
                ORDER BY ordinal_position;
            """, (table,))
            columns = cursor.fetchall()

            constraints = []
            try:
                cursor.execute("""
                    SELECT conname, pg_get_constraintdef(oid)
                    FROM pg_constraint
                    WHERE conrelid = %s::regclass
                """, (table,))
                constraints = sorted(cursor.fetchall(), key=lambda x: x[0])
            except Exception as e:
                print(f"Warning: Could not get constraints for table {table}: {e}")

            indexes = []
            try:
                cursor.execute("""
                    SELECT indexname, indexdef
                    FROM pg_indexes
                    WHERE tablename = %s;
                """, (table,))
                indexes = cursor.fetchall()
            except Exception as e:
                print(f"Warning: Could not get indexes for table {table}: {e}")

            schema[table] = {
                'columns': columns,
                'constraints': constraints,
                'indexes': indexes
            }
        except Exception as e:
            print(f"Error processing table {table}: {e}")
            continue

    cursor.close()
    conn.close()

    filename = f"/test-results/schema_{version}_{suffix}.txt"
    with open(filename, 'w') as f:
        for table, details in schema.items():
            f.write(f"Table: {table}\n")
            f.write("Columns:\n")
            for col in details['columns']:
                f.write(f"  {col[0]}: {col[1]} {'' if col[2] == 'NO' else 'NULL'} {f'DEFAULT {col[3]}' if col[3] else ''}\n")

            f.write("\nConstraints:\n")
            for con in details['constraints']:
                f.write(f"  {con[0]}: {con[1]}\n")

            f.write("\nIndexes:\n")
            for idx in details['indexes']:
                f.write(f"  {idx[0]}: {idx[1]}\n")
            f.write("\n" + "="*50 + "\n\n")

    return filename


def compare_schemas(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

    if lines1 != lines2:
        print(f"Schema mismatch between {file1} and {file2}")
        # посмотрим diff в двух записях бд
        for i, (line1, line2) in enumerate(zip(lines1, lines2)):
            if line1 != line2:
                print(f"Difference at line {i+1}:")
                print(f"File 1: {line1.strip()}")
                print(f"File 2: {line2.strip()}")
        return False
    return True

def test_migration(migration_file):
    version = migration_file.split('__')[0]
    print(f"\nTesting migration: {migration_file}")
    
    conn = get_db_connection()
    conn.autocommit = True
    cursor = conn.cursor()
    
    try:
        print("Step 1: Applying UP script...")
        with open(f"/migrations/{migration_file}", 'r') as f:
            up_script = f.read()
        cursor.execute(up_script)
        
        print("Step 2: Saving first schema...")
        schema1 = save_schema(version, "first")
        
        down_file = migration_file.replace('.sql', '_down.sql')
        if os.path.exists(f"/migrations/{down_file}"):
            print("Step 3: Applying DOWN script...")
            with open(f"/migrations/{down_file}", 'r') as f:
                down_script = f.read()
            cursor.execute(down_script)
        else:
            print("Step 3: No DOWN script found, skipping...")
            return True
        
        print("Step 4: Applying UP script again...")
        cursor.execute(up_script)
        
        print("Step 5: Saving second schema...")
        schema2 = save_schema(version, "second")
        
        print("Step 6: Comparing schemas...")
        return compare_schemas(schema1, schema2)
        
    except Exception as e:
        print(f"Error testing migration {migration_file}: {e}")
        return False
    finally:
        cursor.close()
        conn.close()

def clean_database():
    conn = get_db_connection()
    conn.autocommit = True
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            DO $$ DECLARE
                r RECORD;
            BEGIN
                FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
                    EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
                END LOOP;
            END $$;
        """)
    finally:
        cursor.close()
        conn.close()

def main():
    os.makedirs("/test-results", exist_ok=True)
    
    migration_files = sorted([f for f in os.listdir("/migrations") if f.endswith('.sql') and not f.endswith('_down.sql')])
    
    all_passed = True
    
    for migration_file in migration_files:
        if not test_migration(migration_file):
            print(f"Migration {migration_file} failed idempotency test")
            all_passed = False
        else:
            print(f"Migration {migration_file} passed idempotency test")
    
    if not all_passed:
        print("\nSome migrations failed idempotency tests")
        sys.exit(1)
    else:
        print("\nAll migrations passed idempotency tests")
        sys.exit(0)

if __name__ == "__main__":
    main()