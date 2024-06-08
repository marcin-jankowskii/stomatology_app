
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  static const String id = 'history_screen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment History'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // This should be populated with actual data from a database
            ListTile(
              title: Text('Appointment on 2024-06-10'),
            ),
            ListTile(
              title: Text('Appointment on 2024-06-11'),
            ),
          ],
        ),
      ),
    );
  }
}
