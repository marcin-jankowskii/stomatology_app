import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  static const String id = 'schedule_appointment_screen';
  final int userId;

  ScheduleAppointmentScreen({required this.userId});

  @override
  _ScheduleAppointmentScreenState createState() => _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  List dentists = [];
  Map<DateTime, List<String>> availableTimes = {};
  int? selectedDentistId;
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchDentists();
  }

  Future<void> fetchDentists() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/dentists'), // Endpoint do pobierania listy dentystów
    );

    if (response.statusCode == 200) {
      setState(() {
        dentists = jsonDecode(response.body);
      });
    }
  }

  Future<void> fetchAvailableTimes(int dentistId, DateTime date) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/available_times/$dentistId/${DateFormat('yyyy-MM-dd').format(date)}'), // Endpoint do pobierania wolnych terminów dentysty
    );

    if (response.statusCode == 200) {
      setState(() {
        availableTimes[date] = List<String>.from(jsonDecode(response.body));
      });
    }
  }

  Future<void> scheduleAppointment() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/schedule_appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'patient_id': widget.userId,
        'dentist_id': selectedDentistId,
        'appointment_time': '${DateFormat('yyyy-MM-dd').format(selectedDate)} $selectedTime',
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to schedule appointment'),
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
        title: Text('Schedule Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              hint: Text('Select Dentist'),
              value: selectedDentistId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedDentistId = newValue;
                  selectedTime = null;
                });
                fetchAvailableTimes(newValue!, selectedDate);
              },
              items: dentists.map<DropdownMenuItem<int>>((dentist) {
                return DropdownMenuItem<int>(
                  value: dentist['user_id'],
                  child: Text('${dentist['first_name']} ${dentist['last_name']}'),
                );
              }).toList(),
            ),
            TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime.now().add(Duration(days: 1)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                  selectedTime = null;
                });
                if (selectedDentistId != null) {
                  fetchAvailableTimes(selectedDentistId!, selectedDay);
                }
              },
            ),
            if (selectedDentistId != null && availableTimes[selectedDate] != null)
              DropdownButton<String>(
                hint: Text('Select Time'),
                value: selectedTime,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue;
                  });
                },
                items: availableTimes[selectedDate]!.map<DropdownMenuItem<String>>((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: selectedDentistId != null && selectedTime != null ? scheduleAppointment : null,
              child: Text('Schedule Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
