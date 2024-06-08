import psycopg2

host = "localhost"
dbname = "dentistApp"
user = "postgres"
password = "admin"

conn = psycopg2.connect(
    host=host,
    dbname=dbname,
    user=user,
    password=password
)

cur = conn.cursor()

cur.execute("""
    ALTER TABLE Appointments ADD COLUMN IF NOT EXISTS description TEXT;
""")

conn.commit()
cur.close()
conn.close()

print("Migracja zakończona pomyślnie.")


