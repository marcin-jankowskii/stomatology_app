import psycopg2
from psycopg2 import sql

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

commands = [
    """
    CREATE TABLE IF NOT EXISTS PersonalInfo (
        personal_info_id SERIAL PRIMARY KEY,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        phone_number VARCHAR(15),
        address TEXT
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS Users (
        user_id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        role VARCHAR(50) NOT NULL CHECK (role IN ('dentysta', 'pacjent')),
        personal_info_id INT REFERENCES PersonalInfo(personal_info_id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS Appointments (
        appointment_id SERIAL PRIMARY KEY,
        patient_id INT REFERENCES Users(user_id),
        dentist_id INT REFERENCES Users(user_id),
        appointment_date TIMESTAMP NOT NULL,
        status VARCHAR(50) NOT NULL CHECK (status IN ('zaplanowana', 'odbyta', 'odwołana'))
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS MedicalRecords (
        record_id SERIAL PRIMARY KEY,
        patient_id INT REFERENCES Users(user_id),
        description TEXT,
        date TIMESTAMP NOT NULL
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS Payments (
        payment_id SERIAL PRIMARY KEY,
        appointment_id INT REFERENCES Appointments(appointment_id),
        amount DECIMAL(10, 2) NOT NULL,
        payment_date TIMESTAMP NOT NULL,
        status VARCHAR(50) NOT NULL CHECK (status IN ('opłacona', 'nieopłacona'))
    )
    """
]


for command in commands:
    cur.execute(command)


conn.commit()

cur.close()
conn.close()

print("Tabele zostały pomyślnie utworzone.")
