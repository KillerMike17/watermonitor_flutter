import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSectionTitle('Privacy Policy'),
            const SizedBox(height: 16),
            _buildSectionHeader('1. Data We Collect'),
            _buildBulletPoint('Account info (if registered)'),
            _buildBulletPoint('Water quality measurements'),
            _buildBulletPoint('Location (if enabled)'),
            _buildBulletPoint('Device information'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('2. How We Use Data'),
            _buildBulletPoint('Provide water quality insights'),
            _buildBulletPoint('Improve app functionality'),
            _buildBulletPoint('Anonymous research purposes'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('3. Data Security'),
            _buildBulletPoint('We protect your personal data'),
            _buildBulletPoint('No selling of your information'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('4. Your Choices'),
            _buildBulletPoint('Disable location in settings'),
            _buildBulletPoint('Delete account anytime'),
            
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Last Updated: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue[800],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4)
            ),
          ),
        ],
      ),
    );
  }
}