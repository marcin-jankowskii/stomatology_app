import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentHistoryScreen extends StatefulWidget {
  static const String id = 'payment_history_screen';
  final int userId;

  PaymentHistoryScreen({required this.userId});

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List payments = [];

  @override
  void initState() {
    super.initState();
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/payment_history/${widget.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        payments = jsonDecode(response.body);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load payment history'),
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
        title: Text('Payment History'),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Payment on ${payments[index]['payment_date']}'),
            subtitle: Text('Amount: ${payments[index]['amount']}, Status: ${payments[index]['status']}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Appointment Date: ${payments[index]['appointment_date']}'),
                Text('Dentist: ${payments[index]['dentist_first_name']} ${payments[index]['dentist_last_name']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
