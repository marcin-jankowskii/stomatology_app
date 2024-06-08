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

if __name__ == '__main__':
    app.run(debug=True)
