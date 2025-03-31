import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';
import 'package:login_ui/widgets/custom_drawer.dart';

void main() {
  runApp(WaterMonitoringApp());
}

class WaterMonitoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Using default font for better compatibility
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
  final double waterConsumption = 150.0;
  final double phLevel = 7.2;
  final double turbidityLevel = 5.5;
  final Map<String, bool> sensorStatus = {
    'pH Sensor': true,
    'Turbidity Sensor': true,
    'Flowrate Sensor': false,
  };

  final Map<String, double> _monthlyConsumptionData = {
    'Jan 2025': 150.0,
    'Feb 2025': 140.0,
    'Mar 2025': 160.0,
  };

  String _selectedDate = DateFormat('MMM yyyy').format(DateTime.now());
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
      if (value < 6.5) return 'Poor';
      if (value >= 6.5 && value <= 8.5) return 'Good';
      return 'Poor';
    } else {
      if (value < 5) return 'Poor';
      if (value >= 5 && value <= 10) return 'Good';
      return 'Poor';
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Good':
        return Color(0xFF4CAF50);
      case 'Poor':
        return Color(0xFFF44336);
      default:
        return Color(0xFFFF9800);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          'Water Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
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
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.9, // More compact cards
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCard(
                    context,
                    'Water',
                    '${waterConsumption}L',
                    Icons.water_drop,
                    Color(0xFF00BCD4),
                    _getLevel(waterConsumption),
                  ),
                  _buildCard(
                    context,
                    'pH Level',
                    phLevel.toStringAsFixed(1),
                    Icons.science,
                    Color(0xFF8BC34A),
                    _getLevel(phLevel, isPhLevel: true),
                  ),
                  _buildCard(
                    context,
                    'Turbidity',
                    '${turbidityLevel}NTU',
                    Icons.opacity,
                    Color(0xFFFF9800),
                    _getLevel(turbidityLevel),
                  ),
                  _buildMonthlyConsumptionCard(),
                ],
              ),
              SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _showSensors = !_showSensors;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sensor Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          _showSensors ? Icons.expand_less : Icons.expand_more,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_showSensors)
                Column(
                  children: sensorStatus.entries.map((entry) {
                    return Card(
                      margin: EdgeInsets.only(top: 4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        leading: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: entry.value ? Colors.green[50] : Colors.red[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            entry.value ? Icons.check_circle : Icons.error,
                            color: entry.value ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        trailing: Text(
                          entry.value ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: entry.value ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        minLeadingWidth: 0,
                        dense: true,
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

  Widget _buildCard(BuildContext context, String title, String value,
      IconData icon, Color color, String level) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getLevelColor(level).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: _getLevelColor(level),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyConsumptionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF9C27B0).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.calendar_today, size: 20, color: Color(0xFF9C27B0)),
            ),
            SizedBox(height: 8),
            Text(
              'Monthly',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedDate,
                underline: SizedBox(),
                icon: Icon(Icons.arrow_drop_down, size: 20),
                iconSize: 16,
                style: TextStyle(fontSize: 12),
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
            ),
            SizedBox(height: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_monthlyConsumptionData[_selectedDate] ?? 0.0}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                  ),
                  TextSpan(
                    text: ' liters',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}