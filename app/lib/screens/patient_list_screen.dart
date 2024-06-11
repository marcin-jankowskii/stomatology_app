import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'medical_records_screen.dart';

class PatientListScreen extends StatefulWidget {
  static const String id = 'patient_list_screen';

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<dynamic> patients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/patients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        patients = jsonDecode(response.body);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load patients'),
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
        title: Text('Patients'),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return ListTile(
            title: Text('${patient['first_name']} ${patient['last_name']}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                MedicalRecordsScreen.id,
                arguments: patient['user_id'],
              );
            },
          );
        },
      ),
    );
  }
}
