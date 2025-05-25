import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Our Project'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSectionTitle('Water Monitoring System'),
            const SizedBox(height: 16),
            _buildParagraph('Our smart water monitoring solution helps track and manage water quality in real-time using advanced sensor technology.'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Key Features'),
            _buildFeaturePoint(Icons.speed, 'Flow Rate Sensor', 'Measures water flow velocity and volume accurately'),
            _buildFeaturePoint(Icons.opacity, 'Turbidity Sensor', 'Detects water clarity and suspended particles'),
            _buildFeaturePoint(Icons.power_settings_new, 'Solenoid Valve', 'Automated valve control for water management'),
            _buildFeaturePoint(Icons.phone_android, 'Mobile App', 'Monitor and control your system from anywhere'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('How It Works'),
            _buildStep('1', 'Sensors collect water quality data continuously'),
            _buildStep('2', 'Data is transmitted to our secure cloud'),
            _buildStep('3', 'Mobile app displays real-time analytics'),
            _buildStep('4', 'Control valves remotely when needed'),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Our Mission'),
            _buildParagraph('We aim to provide affordable, reliable water monitoring technology to help communities and industries maintain water quality standards and prevent waste.'),
            
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© ${DateTime.now().year} Water Monitoring Project',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildFeaturePoint(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          height: 1.5,
        ),
      ),
    );
  }
}