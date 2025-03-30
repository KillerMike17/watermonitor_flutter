import 'package:flutter/material.dart';
import 'bill_payment.dart';

void main() {
  runApp(BillingApp());
}

class BillingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Disable debug banner
      home: BillingPage(),
    );
  }
}

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController _accountNumberController = TextEditingController();

  void _submitAccountNumber() {
    final accountNumber = _accountNumberController.text;

    if (accountNumber.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your account number')),
      );
      return;
    }

    // Navigate to BillingDetailsPage with the account number
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BillingDetailsPage(accountNumber: accountNumber),
      ),
    );

    // Clear input field
    _accountNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your Account Number:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: 'Account Number',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitAccountNumber,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text('Submit', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}