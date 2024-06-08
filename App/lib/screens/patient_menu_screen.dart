import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'appointment_screen.dart';
import 'schedule_appointment_screen.dart';
import 'payment_history_screen.dart';

class PatientMenuScreen extends StatelessWidget {
  static const String id = 'patient_menu_screen';

  final int userId;
  final String role;

  PatientMenuScreen({required this.userId, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Menu'),
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
              child: Text('View Appointments'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleAppointmentScreen(userId: userId),
                  ),
                );
              },
              child: Text('Schedule Appointment'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryScreen(userId: userId),
                  ),
                );
              },
              child: Text('Payment History'),
            ),
          ],
        ),
      ),
    );
  }
}
