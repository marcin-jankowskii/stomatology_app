import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'appointment_details_screen.dart';

class AppointmentScreen extends StatefulWidget {
  static const String id = 'appointment_screen';
  final int userId;
  final String role;

  AppointmentScreen({required this.userId, required this.role});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/appointments/${widget.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        appointments = jsonDecode(response.body);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load appointments'),
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
        title: Text('Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Appointment on ${appointments[index]['appointment_date']}'),
            subtitle: Text('Status: ${appointments[index]['status']}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppointmentDetailsScreen.id,
                arguments: {
                  'appointmentId': appointments[index]['appointment_id'],
                  'role': widget.role,
                },
              );
            },
          );
        },
      ),
    );
  }
}
