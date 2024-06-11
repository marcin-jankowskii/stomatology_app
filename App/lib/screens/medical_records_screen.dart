import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicalRecordsScreen extends StatefulWidget {
  static const String id = 'medical_records_screen';

  final int patientId;

  MedicalRecordsScreen({required this.patientId});

  @override
  _MedicalRecordsScreenState createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  List<dynamic> medicalRecords = [];

  @override
  void initState() {
    super.initState();
    fetchMedicalRecords();
  }

  Future<void> fetchMedicalRecords() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/medical_records/${widget.patientId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        medicalRecords = jsonDecode(response.body);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load medical records'),
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
        title: Text('Medical Records'),
      ),
      body: ListView.builder(
        itemCount: medicalRecords.length,
        itemBuilder: (context, index) {
          final record = medicalRecords[index];
          return ListTile(
            title: Text(record['description']),
            subtitle: Text('Date: ${record['date']}, Dentist: ${record['dentist_first_name']} ${record['dentist_last_name']}'),
          );
        },
      ),
    );
  }
}
