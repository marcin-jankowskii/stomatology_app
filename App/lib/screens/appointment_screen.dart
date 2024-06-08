
import 'package:flutter/material.dart';
import 'history_screen.dart';

class AppointmentScreen extends StatefulWidget {
  static const String id = 'appointment_screen';
  
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(hintText: 'Enter appointment date'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement appointment booking logic
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Appointment booked for ${dateController.text}'),
                    );
                  },
                );
              },
              child: Text('Book Appointment'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, HistoryScreen.id);
              },
              child: Text('View Appointments'),
            ),
          ],
        ),
      ),
    );
  }
}
