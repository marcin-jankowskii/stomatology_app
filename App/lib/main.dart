import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/appointment_screen.dart';
import 'screens/patient_menu_screen.dart';
import 'screens/dentist_menu_screen.dart';
import 'screens/schedule_appointment_screen.dart';
import 'screens/appointment_details_screen.dart';
import 'screens/appointment_update_screen.dart';
import 'screens/payment_history_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dentist App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.id,
      onGenerateRoute: (settings) {
        if (settings.name == PatientMenuScreen.id) {
          final args = settings.arguments as Map<String, dynamic>;
          final userId = args['userId'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) {
              return PatientMenuScreen(userId: userId, role: role);
            },
          );
        } else if (settings.name == DentistMenuScreen.id) {
          final args = settings.arguments as Map<String, dynamic>;
          final userId = args['userId'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) {
              return DentistMenuScreen(userId: userId, role: role);
            },
          );
        } else if (settings.name == AppointmentScreen.id) {
          final args = settings.arguments as Map<String, dynamic>;
          final userId = args['userId'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) {
              return AppointmentScreen(userId: userId, role: role);
            },
          );
        } else if (settings.name == ScheduleAppointmentScreen.id) {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return ScheduleAppointmentScreen(userId: userId);
            },
          );
        } else if (settings.name == AppointmentDetailsScreen.id) {
          final args = settings.arguments as Map<String, dynamic>;
          final appointmentId = args['appointmentId'];
          final role = args['role'];
          return MaterialPageRoute(
            builder: (context) {
              return AppointmentDetailsScreen(appointmentId: appointmentId, role: role);
            },
          );
        } else if (settings.name == AppointmentUpdateScreen.id) {
          final appointmentId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return AppointmentUpdateScreen(appointmentId: appointmentId);
            },
          );
        } else if (settings.name == PaymentHistoryScreen.id) {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return PaymentHistoryScreen(userId: userId);
            },
          );
        }
        return null;
      },
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
