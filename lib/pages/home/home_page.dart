import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';

void main() {
  runApp(WaterMonitoringApp());
}

class WaterMonitoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Monitoring Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final double waterConsumption = 150.0; // in liters
  final double phLevel = 7.2; // pH level
  final double turbidityLevel = 5.5; // in NTU
  final Map<String, bool> sensorStatus = {
    'pH Sensor': true,
    'Turbidity Sensor': true,
    'Flowrate Sensor': false,
  };

  final Map<String, double> _monthlyConsumptionData = {
    '2025-01-01': 150.0,
    '2025-02-01': 140.0,
    '2025-03-01': 160.0,
  };

  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool _showSensors = false;

  @override
  void initState() {
    super.initState();
    if (!_monthlyConsumptionData.containsKey(_selectedDate)) {
      _selectedDate = _monthlyConsumptionData.keys.first;
    }
  }

  String _getLevel(double value, {bool isPhLevel = false}) {
    if (isPhLevel) {
      if (value < 6.5) return 'Worse';
      if (value >= 6.5 && value <= 8.5) return 'Good';
      return 'Bad';
    } else {
      if (value < 5) return 'Worse';
      if (value >= 5 && value <= 10) return 'Good';
      return 'Bad';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Monitoring Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCard(
                    context,
                    'Water Consumption',
                    '${waterConsumption} liters',
                    Icons.water_drop,
                    Colors.blue,
                    _getLevel(waterConsumption),
                  ),
                  _buildCard(
                    context,
                    'pH Level',
                    'pH: $phLevel',
                    Icons.science,
                    Colors.green,
                    _getLevel(phLevel, isPhLevel: true),
                  ),
                  _buildCard(
                    context,
                    'Turbidity Level',
                    '$turbidityLevel NTU',
                    Icons.opacity,
                    Colors.orange,
                    _getLevel(turbidityLevel),
                  ),
                  _buildMonthlyConsumptionCard(),
                ],
              ),
              SizedBox(height: 8),
              Card(
                elevation: 4,
                child: ListTile(
                  title: Text(
                    'Sensor Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(_showSensors ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _showSensors = !_showSensors;
                      });
                    },
                  ),
                ),
              ),
              if (_showSensors)
                Column(
                  children: sensorStatus.entries.map((entry) {
                    return Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(entry.key),
                        trailing: Icon(
                          entry.value ? Icons.check_circle : Icons.cancel,
                          color: entry.value ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String level) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 120, // Set the height of the card
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Level: $level',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: level == 'Good' ? Colors.green : level == 'Bad' ? Colors.orange : Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyConsumptionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.calendar_today, size: 30, color: Colors.purple),
            SizedBox(height: 8),
            Text(
              'Monthly Consumption',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedDate,
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _selectedDate) {
                  setState(() {
                    _selectedDate = newValue;
                  });
                } 
              },
              items: _monthlyConsumptionData.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
            SizedBox(height: 4),
            Text(
              'Consumption: ${_monthlyConsumptionData[_selectedDate] ?? 0.0} liters',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
