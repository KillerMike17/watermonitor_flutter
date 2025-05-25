import 'package:flutter/material.dart';

class BillingHistoryPage extends StatefulWidget {
  const BillingHistoryPage({Key? key}) : super(key: key);

  @override
  _BillingHistoryPageState createState() => _BillingHistoryPageState();
}

class _BillingHistoryPageState extends State<BillingHistoryPage> {
  List<Map<String, dynamic>> paymentHistory = [
    {
      'date': 'Today, 10:30 AM',
      'amount': 7.50,
      'waterUsed': '150 L',
      'rate': '0.05 ETB/L',
      'status': 'Paid',
      'method': 'Chapa'
    },
    {
      'date': 'Yesterday, 2:15 PM',
      'amount': 6.25,
      'waterUsed': '125 L',
      'rate': '0.05 ETB/L',
      'status': 'Paid',
      'method': 'Chapa'
    },
    {
      'date': 'May 15, 2023',
      'amount': 8.00,
      'waterUsed': '160 L',
      'rate': '0.05 ETB/L',
      'status': 'Failed',
      'method': 'Chapa'
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: paymentHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No payment history yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: paymentHistory.length,
              itemBuilder: (context, index) {
                final payment = paymentHistory[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${payment['amount']?.toStringAsFixed(2)} ETB',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(payment['status'])
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getStatusColor(payment['status']),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                payment['status'],
                                style: TextStyle(
                                  color: _getStatusColor(payment['status']),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Water Usage Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Water Used:'),
                            Text(payment['waterUsed']),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rate:'),
                            Text(payment['rate']),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 4),
                            Text(
                              payment['method'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 4),
                            Text(
                              payment['date'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}