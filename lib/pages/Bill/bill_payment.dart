import 'package:flutter/material.dart';
import 'bill_history.dart';

class BillingDetailsPage extends StatelessWidget {
  final String accountNumber;
  final double monthlyConsumption = 150.0; // in liters
  final double pricePerLiter = 0.05;

  BillingDetailsPage({required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    final totalCost = monthlyConsumption * pricePerLiter;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Bill'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BillingHistoryPage(accountNumber: accountNumber),
                ),
              );
            },
            tooltip: 'Payment History',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Billing Summary
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text('Account: $accountNumber',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Water Used:'),
                      Text('$monthlyConsumption L'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rate:'),
                      Text('\$$pricePerLiter/L'),
                    ],
                  ),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Due:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${totalCost.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                              fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Payment Section
            Text('Pay with:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Chapa'),
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            Spacer(),

            // History Button - Improved
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BillingHistoryPage(accountNumber: accountNumber),
                    ),
                  );
                },
                child: Text('VIEW PAYMENT HISTORY'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.blue,
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing payment with Chapa')));
                },
                child: Text('Pay Now'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
