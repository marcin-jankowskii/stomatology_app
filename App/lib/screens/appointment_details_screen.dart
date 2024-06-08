import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'appointment_update_screen.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  static const String id = 'appointment_details_screen';
  final int appointmentId;
  final String role;

  AppointmentDetailsScreen({required this.appointmentId, required this.role});

  @override
  _AppointmentDetailsScreenState createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  Map<String, dynamic>? appointmentDetails;

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/appointment/${widget.appointmentId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        appointmentDetails = jsonDecode(response.body);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load appointment details'),
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
        title: Text('Appointment Details'),
        actions: widget.role == 'dentysta'
            ? [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentUpdateScreen(appointmentId: widget.appointmentId),
                      ),
                    );
                  },
                ),
              ]
            : [],
      ),
      body: appointmentDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appointment ID: ${appointmentDetails!['appointment_id']}'),
                  Text('Date: ${appointmentDetails!['appointment_date']}'),
                  Text('Status: ${appointmentDetails!['status']}'),
                  SizedBox(height: 16.0),
                  Text('Patient Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Name: ${appointmentDetails!['patient_first_name']} ${appointmentDetails!['patient_last_name']}'),
                  Text('Phone: ${appointmentDetails!['patient_phone']}'),
                  Text('Address: ${appointmentDetails!['patient_address']}'),
                  SizedBox(height: 16.0),
                  Text('Dentist Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Name: ${appointmentDetails!['dentist_first_name']} ${appointmentDetails!['dentist_last_name']}'),
                  Text('Phone: ${appointmentDetails!['dentist_phone']}'),
                  Text('Address: ${appointmentDetails!['dentist_address']}'),
                  SizedBox(height: 16.0),
                  Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(appointmentDetails!['description'] ?? 'No description'),
                  SizedBox(height: 16.0),
                  Text('Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(appointmentDetails!['amount'] != null ? '${appointmentDetails!['amount']}' : 'None'),
                ],
              ),
            ),
    );
  }
}
