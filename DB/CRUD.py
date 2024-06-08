import psycopg2

def add_dentist(dbname, user, password, host):
    conn = psycopg2.connect(
        dbname=dbname,
        user=user,
        password=password,
        host=host
    )
    cur = conn.cursor()

    try:
        insert_personal_info = """
        INSERT INTO PersonalInfo (first_name, last_name, phone_number, address)
        VALUES (%s, %s, %s, %s) RETURNING personal_info_id;
        """
        cur.execute(insert_personal_info, ('Jan', 'Kowalski', '500-600-700', 'ul. Miodowa 10, 00-001 Warszawa'))
        personal_info_id = cur.fetchone()[0]

        insert_user = """
        INSERT INTO Users (email, password, role, personal_info_id)
        VALUES (%s, %s, %s, %s);
        """
        cur.execute(insert_user, ('jan.kowalski@example.com', 'bezpieczne_haslo123', 'dentysta', personal_info_id))

        conn.commit()
        print("Dentysta został pomyślnie dodany do bazy danych.")
    except Exception as e:
        print("Wystąpił błąd:", e)
        conn.rollback()
    finally:
        cur.close()
        conn.close()

add_dentist('dentistApp', 'postgres', 'admin', 'localhost')
