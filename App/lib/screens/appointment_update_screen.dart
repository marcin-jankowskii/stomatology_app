import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentUpdateScreen extends StatefulWidget {
  static const String id = 'appointment_update_screen';
  final int appointmentId;

  AppointmentUpdateScreen({required this.appointmentId});

  @override
  _AppointmentUpdateScreenState createState() => _AppointmentUpdateScreenState();
}

class _AppointmentUpdateScreenState extends State<AppointmentUpdateScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? status;

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

    if (response.statusCode == 200) {
      final appointmentDetails = jsonDecode(response.body);
      setState(() {
        descriptionController.text = appointmentDetails['description'] ?? '';
        amountController.text = appointmentDetails['amount']?.toString() ?? '';
        status = appointmentDetails['status'];
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

  Future<void> updateAppointment() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/update_appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'appointment_id': widget.appointmentId,
        'description': descriptionController.text,
        'status': status,
        'amount': double.tryParse(amountController.text),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update appointment'),
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
        title: Text('Update Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              hint: Text('Select Status'),
              value: status,
              onChanged: (String? newValue) {
                setState(() {
                  status = newValue;
                });
              },
              items: <String>['zaplanowana', 'odbyta, nieopłacona', 'odbyta, opłacona', 'odwołana']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: updateAppointment,
              child: Text('Update Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
