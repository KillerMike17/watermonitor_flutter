import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_ui/pages/Bill/bill_history.dart';
import 'package:login_ui/pages/Bill/payment_confirmation_page.dart';
import 'package:login_ui/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/payment_dto.dart';
import '../../services/payment_api_service.dart';

// models/billing_info_model.dart

class BillingInfo {
  final String uuid;
  final String userId;
  final DateTime dueDate;
  final double amount;
  final String status;
  final List<BillingBreakdown> breakdown;

  BillingInfo({
    required this.uuid,
    required this.userId,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.breakdown,
  });

  factory BillingInfo.fromJson(Map<String, dynamic> json) {
    return BillingInfo(
      uuid: json['uuid'],
      userId: json['userId'],
      dueDate: DateTime.parse(json['dueDate']),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      breakdown: (json['breakdown'] as List)
          .map((item) => BillingBreakdown.fromJson(item))
          .toList(),
    );
  }
}

class BillingBreakdown {
  final DateTime date;
  final int waterConsumption;
  final double charge;

  BillingBreakdown({
    required this.date,
    required this.waterConsumption,
    required this.charge,
  });

  factory BillingBreakdown.fromJson(Map<String, dynamic> json) {
    return BillingBreakdown(
      date: DateTime.parse(json['date']),
      waterConsumption: json['waterConsumption'],
      charge: (json['charge'] as num).toDouble(),
    );
  }
}

/// Main page for displaying water bill details and payment options.
class BillingDetailsPage extends StatefulWidget {
  const BillingDetailsPage({Key? key}) : super(key: key);

  @override
  State<BillingDetailsPage> createState() => _BillingDetailsPageState();
}

class _BillingDetailsPageState extends State<BillingDetailsPage> {
  late Future<BillingInfo> _billingInfoFuture;
  final PaymentApiService _paymentApiService =
      PaymentApiService(); // Instantiate service
  final ApiService _apiService = ApiService(); // Instantiate service

  @override
  void initState() {
    super.initState();
    _refreshBillingInfo(); // Initial fetch
  }

  // New method to refresh billing info
  Future<void> _refreshBillingInfo() async {
    setState(() {
      _billingInfoFuture = _apiService.getPaymentInfo();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: FutureBuilder<BillingInfo>(
        future: _billingInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Error loading billing info: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                       onPressed: () {
                        _refreshBillingInfo(); // Retry
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final billingInfo = snapshot.data!;
            final formattedDueDate =
                DateFormat('dd/MM/yyyy').format(billingInfo.dueDate);

            // Assuming the last entry in breakdown is for the current month's bill
            // You might need more sophisticated logic based on how your API defines 'current bill'
            double currentMonthWaterConsumption = 0;
            double currentMonthCharge = 0;
            double pricePerLiter = 0.0; // Initialize price per liter

            if (billingInfo.breakdown.isNotEmpty) {
              currentMonthWaterConsumption =
                  billingInfo.breakdown.last.waterConsumption.toDouble();
              currentMonthCharge = billingInfo.breakdown.last.charge;
              if (currentMonthWaterConsumption > 0) {
                pricePerLiter =
                    currentMonthCharge / currentMonthWaterConsumption;
              }
            }
            // Calculate total consumption for the month from the breakdown
            double totalMonthlyConsumption = billingInfo.breakdown
                .fold(0.0, (sum, item) => sum + item.waterConsumption);

            // The price per liter can be derived from the total amount and total consumption,
            // or from the breakdown if it's consistent.
            // Using total amount / total consumption for overall average rate.
            if (totalMonthlyConsumption > 0) {
              pricePerLiter = billingInfo.amount / totalMonthlyConsumption;
            } else {
              // Fallback if no consumption data or consumption is zero
              pricePerLiter = 0.05; // Default rate if no consumption
            }

            return SingleChildScrollView(
              // Use SingleChildScrollView for potential overflow
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Bill',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  _CurrentBillCard(
                    monthlyConsumption: totalMonthlyConsumption,
                    pricePerLiter: pricePerLiter,
                    formattedDueDate: formattedDueDate,
                    totalCost: billingInfo.amount, // Use total amount from API
                  ),
                  const SizedBox(height: 30),
                  Text('Detailed Breakdown',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  _BillingBreakdownList(breakdown: billingInfo.breakdown),
                  const SizedBox(height: 30),
                  Text('Payment Methods',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  _ChapaPaymentButton(
                      onPressed: () =>
                          _processChapaPayment(context, billingInfo.amount)),
                  const SizedBox(height: 10),
                  const Text(
                    'Other payment methods coming soon',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(
                      height: 20), // Add some spacing before the last button
                  _ActionButton(
                    text: 'VIEW PAYMENT HISTORY',
                    icon: Icons.history,
                    color: Colors.blue,
                    onPressed: () {
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
            );
          }
          return const SizedBox.shrink(); // Fallback for other states
        },
      ),
    );
  }

  /// Builds the AppBar for the BillingDetailsPage.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Water Bill'),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
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
    );
  }

  /// Displays an error dialog.
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Displays a success dialog and navigates to the home screen.
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Info'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              //   Navigator.popUntil(
              //       context, ModalRoute.withName('/')); // Navigate to home
            },
          )
        ],
      ),
    );
  }

  /// Initiates the Chapa payment process.
  void _processChapaPayment(BuildContext context, double amount) async {
    print('[DEBUG] Starting payment process...');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      final userJson = prefs.getString('user');

      if (token.isEmpty || userJson == null) {
        _showErrorDialog(context, 'Login info missing.');
        return;
      }

      final user = jsonDecode(userJson);

      final paymentDto = PaymentDto(
        returnUrl:
            'https://water-monitoring-api-k06t.onrender.com/payment/status',
        email: user['email'],
        first_name: user['firstName'],
        last_name: user['lastName'],
        userId: user['uuid'],
        description: 'Water bill payment for the month',
        title: 'Water Bill Payment',
        uuid: user['uuid'],
        currency: 'ETB',
        // amount: amount, // Use the fetched amount
      );

      final checkoutUrl =
          await PaymentApiService.initiateChapaPayment(paymentDto, token);

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);

          // --- DID YOU PAY? DIALOG ---
          final didPay = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Did you complete the payment?'),
              content: const Text(
                  'Please confirm if you have successfully completed the payment in your browser.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No, I haven\'t paid'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes, I paid'),
                ),
              ],
            ),
          );

          if (didPay == true) {
            // User confirmed payment, re-fetch payment info
            final updatedBillingInfo = await _apiService.getPaymentInfo();

            if (updatedBillingInfo.status == "paid") {
                          await _refreshBillingInfo(); // <--- THIS IS THE KEY CHANGE


              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillingHistoryPage(),
                ),
              );
            } else {
              _showErrorDialog(context, 'Payment not detected.');
            }
          } else {
            _showSuccessDialog(context,
                'Payment process was not completed. Please try again.');
          }
        } else {
          _showErrorDialog(context, 'Could not launch payment URL.');
        }
      } else {
        _showErrorDialog(context, 'Failed to initiate payment.');
      }
    } catch (e) {
      _showErrorDialog(context, 'An error occurred: $e');
    }
  }
}

/// A card displaying the current bill details.
class _CurrentBillCard extends StatelessWidget {
  final double monthlyConsumption;
  final double pricePerLiter;
  final String formattedDueDate;
  final double totalCost;

  const _CurrentBillCard({
    required this.monthlyConsumption,
    required this.pricePerLiter,
    required this.formattedDueDate,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _BillingRow('Billing Period', 'Total unpaid month/s'),
            _BillingRow('Billing up to', formattedDueDate),
            const Divider(height: 24),
            _BillingRow(
                'Water Used', '${monthlyConsumption.toStringAsFixed(2)} L'),
            _BillingRow('Rate', '\$${pricePerLiter.toStringAsFixed(2)}/L'),
            const Divider(height: 24),
            _BillingRow(
              'Total Amount Due',
              '\$${totalCost.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// A single row for displaying a billing detail (label and value).
class _BillingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _BillingRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red[700] : null,
              fontSize: isTotal ? 18 : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget to display the detailed billing breakdown.
class _BillingBreakdownList extends StatelessWidget {
  final List<BillingBreakdown> breakdown;

  const _BillingBreakdownList({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return const Text('No detailed breakdown available.');
    }

    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true, // Important to prevent unbounded height in a Column
        physics:
            const NeverScrollableScrollPhysics(), // Disable scrolling of this list
        itemCount: breakdown.length,
        itemBuilder: (context, index) {
          final item = breakdown[index];
          // final formattedDate = DateFormat('MMM dd, YYYY').format(item.date); final formattedMonthYear = DateFormat('MMMM YYYY').format(item.date);
          final formattedMonthYear = DateFormat('MMMM YYYY').format(item.date);

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Month of: $formattedMonthYear', // Changed this line
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Water Used: ${item.waterConsumption} L'),
                    Text('Charge: \$${item.charge.toStringAsFixed(2)}'),
                  ],
                ),
                if (index < breakdown.length - 1) const Divider(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A button for initiating Chapa payments.
class _ChapaPaymentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ChapaPaymentButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: Colors.white),
            SizedBox(width: 10),
            Text('Pay with Chapa', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// A generic action button with an icon and text.
class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
