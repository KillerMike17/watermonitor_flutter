import 'package:flutter/material.dart';

class BillingDetailsPage extends StatelessWidget {
  final String accountNumber;
  final double waterConsumption = 150.0; // Example water usage in liters
  final double pricePerLiter = 0.05; // Cost per liter
  final List<String> paymentMethods = ['Credit Card', 'Mobile Money', 'PayPal'];

  BillingDetailsPage({required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    double totalCost = waterConsumption * pricePerLiter;

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Account Number: $accountNumber',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Water Consumption: $waterConsumption liters',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Cost per Liter: \$${pricePerLiter.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Total Cost: \$${totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: paymentMethods.map((method) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment via $method selected')),
                    );
                  },
                  child: Text(method),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment processing...')),
                );
              },
              child: Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}