import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> registerUser(String email, String password, String firstName, String lastName, String phoneNumber, String address) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/register'),  // Użyj '10.0.2.2' dla emulatora Androida
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'role': 'pacjent',  // Zakładam, że użytkownik rejestruje się jako pacjent
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'address': address,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushNamed(context, LoginScreen.id);  // Powrót do ekranu logowania po rejestracji
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Registration failed'),
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
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(hintText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(hintText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(hintText: 'Phone Number'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(hintText: 'Address'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                registerUser(
                  emailController.text,
                  passwordController.text,
                  firstNameController.text,
                  lastNameController.text,
                  phoneNumberController.text,
                  addressController.text
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
