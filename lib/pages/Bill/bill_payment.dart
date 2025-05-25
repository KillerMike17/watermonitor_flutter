import 'package:flutter/material.dart';
import 'bill_history.dart';

class BillingDetailsPage extends StatelessWidget {
  final double monthlyConsumption = 150.0; // in liters
  final double pricePerLiter = 0.05;
  final DateTime dueDate = DateTime.now().add(Duration(days: 15));

  BillingDetailsPage();

  @override
  Widget build(BuildContext context) {
    final totalCost = monthlyConsumption * pricePerLiter;
    final formattedDueDate = '${dueDate.day}/${dueDate.month}/${dueDate.year}';

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
                  builder: (context) => BillingHistoryPage(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Overview
            Text('Current Bill', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            
            // Billing Summary Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildBillingRow('Billing Period', 'This Month'),
                    _buildBillingRow('Due Date', formattedDueDate),
                    Divider(height: 24),
                    _buildBillingRow('Water Used', '$monthlyConsumption L'),
                    _buildBillingRow('Rate', '\$$pricePerLiter/L'),
                    Divider(height: 24),
                    _buildBillingRow(
                      'Total Amount Due',
                      '\$${totalCost.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Payment Methods Section
            Text('Payment Methods', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            
            // Chapa Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _processChapaPayment(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple, // Chapa's brand color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Pay with Chapa', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Other payment methods coming soon', 
                style: TextStyle(color: Colors.grey, fontSize: 12)),

            Spacer(),

            // Payment History Button
            _buildActionButton(
              context,
              'VIEW PAYMENT HISTORY',
              Icons.history,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillingHistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          )),
          Text(value, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.red[700] : null,
            fontSize: isTotal ? 18 : null,
          )),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  void _processChapaPayment(BuildContext context) {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Processing Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Connecting to Chapa...'),
          ],
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment processed successfully with Chapa'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}