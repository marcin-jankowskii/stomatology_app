import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'patient_menu_screen.dart';
import 'dentist_menu_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/login'),  // Użyj '10.0.2.2' dla emulatora Androida
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final userId = responseBody['user_id'];
      final role = responseBody['role'];

      if (role == 'pacjent') {
        Navigator.pushReplacementNamed(
          context,
          PatientMenuScreen.id,
          arguments: {'userId': userId, 'role': role},
        );
      } else if (role == 'dentysta') {
        Navigator.pushReplacementNamed(
          context,
          DentistMenuScreen.id,
          arguments: {'userId': userId, 'role': role},
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid credentials'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white), // Set "Login" text color to white
        ),
        backgroundColor: Color.fromARGB(2255, 62, 189, 196), // Set AppBar background color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60.0),
            // Add App Name
            Text(
              'DentApp',
              style: TextStyle(
                fontSize: 36.0, // Increase font size
                color: Color.fromARGB(2255, 62, 189, 196), // Lighter aquamarine-like color
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            // Add Logo
            Image.asset(
              'assets/logo2.jpg',
              height: 150.0,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                loginUser(emailController.text, passwordController.text);
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Set button text color to white
              ), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 72, 206, 213), // More blueish turquoise color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
