import psycopg2


def display_dentists(dbname, user, password, host):
    conn = psycopg2.connect(
        dbname=dbname,
        user=user,
        password=password,
        host=host
    )
    cur = conn.cursor()

    try:
        query = """
        SELECT first_name, last_name, phone_number, address, email
        FROM Users
        JOIN PersonalInfo ON Users.personal_info_id = PersonalInfo.personal_info_id
        WHERE role = 'dentysta';
        """
        cur.execute(query)

        dentists = cur.fetchall()

        if dentists:
            print("Lista dentystów:")
            for dentist in dentists:
                print(
                    f"Imię i nazwisko: {dentist[0]} {dentist[1]}, Telefon: {dentist[2]}, Adres: {dentist[3]}, Email: {dentist[4]}")
        else:
            print("Brak zarejestrowanych dentystów.")

    except Exception as e:
        print("Wystąpił błąd:", e)
    finally:
        cur.close()
        conn.close()

display_dentists('dentistApp', 'postgres', 'ZAQ!2wsx', 'localhost')
