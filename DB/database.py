from flask import Flask, request, jsonify
import psycopg2

app = Flask(__name__)

host = "localhost"
dbname = "dentistApp"
user = "postgres"
password = "admin"

def get_db_connection():
    conn = psycopg2.connect(
        host=host,
        dbname=dbname,
        user=user,
        password=password
    )
    return conn

#edff
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM Users WHERE email = %s AND password = %s", (email, password))
    user = cur.fetchone()
    cur.close()
    conn.close()
    
    if user:
        return jsonify({"message": "Login successful", "user_id": user[0]}), 200
    else:
        return jsonify({"message": "Invalid credentials"}), 401

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    role = data.get('role')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    phone_number = data.get('phone_number')
    address = data.get('address')

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO PersonalInfo (first_name, last_name, phone_number, address) VALUES (%s, %s, %s, %s) RETURNING personal_info_id",
                (first_name, last_name, phone_number, address))
    personal_info_id = cur.fetchone()[0]
    cur.execute("INSERT INTO Users (email, password, role, personal_info_id) VALUES (%s, %s, %s, %s)",
                (email, password, role, personal_info_id))
    conn.commit()
    cur.close()
    conn.close()
    
    return jsonify({"message": "User registered successfully"}), 201

<<<<<<< Updated upstream
=======
@app.route('/dentists', methods=['GET'])
def get_dentists():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT u.user_id, p.first_name, p.last_name FROM Users u JOIN PersonalInfo p ON u.personal_info_id = p.personal_info_id WHERE u.role = 'dentysta'")
    dentists = cur.fetchall()
    cur.close()
    conn.close()
    
    dentist_list = [{"user_id": dentist[0], "first_name": dentist[1], "last_name": dentist[2]} for dentist in dentists]
    return jsonify(dentist_list)

@app.route('/patients', methods=['GET'])
def get_patients():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT u.user_id, p.first_name, p.last_name FROM Users u JOIN PersonalInfo p ON u.personal_info_id = p.personal_info_id WHERE u.role = 'pacjent'")
    patients = cur.fetchall()
    cur.close()
    conn.close()
    
    patient_list = [{"user_id": patient[0], "first_name": patient[1], "last_name": patient[2]} for patient in patients]
    return jsonify(patient_list)

@app.route('/medical_records/<int:patient_id>', methods=['GET'])
def get_medical_records(patient_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT r.record_id, r.description, r.date, d.first_name, d.last_name
        FROM MedicalRecords r
        JOIN Users u ON r.patient_id = u.user_id
        JOIN PersonalInfo p ON u.personal_info_id = p.personal_info_id
        JOIN Users d_user ON r.patient_id = d_user.user_id
        JOIN PersonalInfo d ON d_user.personal_info_id = d.personal_info_id
        WHERE r.patient_id = %s
    """, (patient_id,))
    records = cur.fetchall()
    cur.close()
    conn.close()
    
    medical_records = [{
        "record_id": record[0],
        "description": record[1],
        "date": record[2].strftime('%Y-%m-%d %H:%M:%S'),
        "dentist_first_name": record[3],
        "dentist_last_name": record[4]
    } for record in records]

    return jsonify(medical_records)

@app.route('/available_times/<int:dentist_id>/<date>', methods=['GET'])
def get_available_times(dentist_id, date):
    start_time = datetime.strptime("07:00", "%H:%M")
    end_time = datetime.strptime("16:00", "%H:%M")
    date = datetime.strptime(date, "%Y-%m-%d")
    time_slots = []
    current_time = start_time

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT appointment_date FROM Appointments WHERE dentist_id = %s AND DATE(appointment_date) = %s", (dentist_id, date))
    booked_slots = [row[0].strftime("%H:%M") for row in cur.fetchall()]
    cur.close()
    conn.close()

    while current_time < end_time:
        time_slot = current_time.strftime("%H:%M")
        if time_slot not in booked_slots:
            time_slots.append(time_slot)
        current_time += timedelta(minutes=30)
    return jsonify(time_slots)

@app.route('/schedule_appointment', methods=['POST'])
def schedule_appointment():
    data = request.json
    patient_id = data.get('patient_id')
    dentist_id = data.get('dentist_id')
    appointment_time = data.get('appointment_time')
    
    appointment_datetime = datetime.strptime(appointment_time, '%Y-%m-%d %H:%M')
    if appointment_datetime.date() <= datetime.now().date():
        return jsonify({"message": "Cannot schedule an appointment for today or past dates"}), 400

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO Appointments (patient_id, dentist_id, appointment_date, status) VALUES (%s, %s, %s, %s)",
                (patient_id, dentist_id, appointment_time, 'zaplanowana'))
    conn.commit()
    cur.close()
    conn.close()
    
    return jsonify({"message": "Appointment scheduled successfully"}), 201

@app.route('/appointments/<int:user_id>', methods=['GET'])
def get_appointments(user_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT DISTINCT ON (a.appointment_id) 
               a.appointment_id, a.appointment_date, a.status, 
               p.first_name, p.last_name, p.phone_number, p.address 
        FROM Appointments a
        JOIN Users u ON a.dentist_id = u.user_id OR a.patient_id = u.user_id
        JOIN PersonalInfo p ON u.personal_info_id = p.personal_info_id
        WHERE a.patient_id = %s OR a.dentist_id = %s
    """, (user_id, user_id))
    appointments = cur.fetchall()
    cur.close()
    conn.close()
    
    appointment_list = [{
        "appointment_id": appointment[0],
        "appointment_date": appointment[1].strftime('%Y-%m-%d %H:%M:%S'),
        "status": appointment[2],
        "first_name": appointment[3],
        "last_name": appointment[4],
        "phone_number": appointment[5],
        "address": appointment[6]
    } for appointment in appointments]

    return jsonify(appointment_list)

@app.route('/appointment/<int:appointment_id>', methods=['GET'])
def get_appointment_details(appointment_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT a.appointment_id, a.appointment_date, a.status, 
               p1.first_name AS patient_first_name, p1.last_name AS patient_last_name, p1.phone_number AS patient_phone, p1.address AS patient_address,
               p2.first_name AS dentist_first_name, p2.last_name AS dentist_last_name, p2.phone_number AS dentist_phone, p2.address AS dentist_address,
               a.description, a.amount
        FROM Appointments a
        JOIN Users u1 ON a.patient_id = u1.user_id
        JOIN PersonalInfo p1 ON u1.personal_info_id = p1.personal_info_id
        JOIN Users u2 ON a.dentist_id = u2.user_id
        JOIN PersonalInfo p2 ON u2.personal_info_id = p2.personal_info_id
        WHERE a.appointment_id = %s
    """, (appointment_id,))
    appointment = cur.fetchone()
    cur.close()
    conn.close()

    if appointment:
        appointment_details = {
            "appointment_id": appointment[0],
            "appointment_date": appointment[1].strftime('%Y-%m-%d %H:%M:%S'),
            "status": appointment[2],
            "patient_first_name": appointment[3],
            "patient_last_name": appointment[4],
            "patient_phone": appointment[5],
            "patient_address": appointment[6],
            "dentist_first_name": appointment[7],
            "dentist_last_name": appointment[8],
            "dentist_phone": appointment[9],
            "dentist_address": appointment[10],
            "description": appointment[11],
            "amount": appointment[12],
        }
        return jsonify(appointment_details)
    else:
        return jsonify({"message": "Appointment not found"}), 404

@app.route('/update_appointment', methods=['POST'])
def update_appointment():
    data = request.json
    appointment_id = data.get('appointment_id')
    description = data.get('description')
    status = data.get('status')
    amount = data.get('amount')

    conn = get_db_connection()
    cur = conn.cursor()

    # Pobierz istniejące szczegóły wizyty
    cur.execute("SELECT patient_id, dentist_id, appointment_date FROM Appointments WHERE appointment_id = %s", (appointment_id,))
    appointment = cur.fetchone()
    if not appointment:
        return jsonify({"message": "Appointment not found"}), 404

    patient_id, dentist_id, appointment_date = appointment

    # Aktualizacja wizyty
    cur.execute("""
        UPDATE Appointments
        SET description = %s, status = %s, amount = %s
        WHERE appointment_id = %s
    """, (description, status, amount, appointment_id))

    # Sprawdzenie, czy istnieje płatność
    cur.execute("SELECT payment_id FROM Payments WHERE appointment_id = %s", (appointment_id,))
    payment = cur.fetchone()

    if payment:
        # Aktualizacja istniejącej płatności
        cur.execute("""
            UPDATE Payments
            SET amount = %s, payment_date = %s, status = %s
            WHERE appointment_id = %s
        """, (amount, datetime.now(), 'opłacona', appointment_id))
    elif status == 'odbyta, opłacona':
        # Dodanie nowej płatności
        cur.execute("""
            INSERT INTO Payments (appointment_id, amount, payment_date, status)
            VALUES (%s, %s, %s, %s)
        """, (appointment_id, amount, datetime.now(), 'opłacona'))

    # Dodanie do MedicalRecords
    cur.execute("""
        INSERT INTO MedicalRecords (patient_id, description, date)
        VALUES (%s, %s, %s)
    """, (patient_id, description, appointment_date))

    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"message": "Appointment updated successfully"}), 200

@app.route('/payment_history/<int:patient_id>', methods=['GET'])
def get_payment_history(patient_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT p.payment_id, p.amount, p.payment_date, p.status, 
               a.appointment_date, d.first_name, d.last_name
        FROM Payments p
        JOIN Appointments a ON p.appointment_id = a.appointment_id
        JOIN Users u ON a.dentist_id = u.user_id
        JOIN PersonalInfo d ON u.personal_info_id = d.personal_info_id
        WHERE a.patient_id = %s
    """, (patient_id,))
    payments = cur.fetchall()
    cur.close()
    conn.close()
    
    payment_history = [{
        "payment_id": payment[0],
        "amount": payment[1],
        "payment_date": payment[2].strftime('%Y-%m-%d %H:%M:%S'),
        "status": payment[3],
        "appointment_date": payment[4].strftime('%Y-%m-%d %H:%M:%S'),
        "dentist_first_name": payment[5],
        "dentist_last_name": payment[6]
    } for payment in payments]

    return jsonify(payment_history)

>>>>>>> Stashed changes
if __name__ == '__main__':
    app.run(debug=True)
