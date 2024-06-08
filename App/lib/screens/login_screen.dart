import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'registration_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
