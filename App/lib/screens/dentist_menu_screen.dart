import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'appointment_screen.dart';
import 'registration_screen.dart';

class DentistMenuScreen extends StatelessWidget {
  static const String id = 'dentist_menu_screen';

  final int userId;
  final String role;

  DentistMenuScreen({required this.userId, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dentist Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppointmentScreen.id,
                  arguments: {'userId': userId, 'role': role},
                );
              },
              child: Text('Manage Appointments'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              child: Text('Add User'),
            ),
            // Dodaj inne opcje menu dla dentystów
          ],
        ),
      ),
    );
  }
}
