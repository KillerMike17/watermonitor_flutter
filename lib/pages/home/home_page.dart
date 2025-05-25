import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';
import 'package:login_ui/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/websocket_service.dart'; // Adjust import path accordingly
import '../../services/api_service.dart'; // Adjust this path if needed

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double flowRate = 0.0;
  double turbidityLevel = 0.0;
  bool _isConnected = false;
  bool _valveStatus = false; // false = closed, true = open
  bool _isTogglingValve = false;
  final ApiService _apiService = ApiService();

  late WebSocketService _wsService;

  final Map<String, double> _monthlyConsumptionData = {
    'Jan 2025': 150.0,
    'Feb 2025': 140.0,
    'Mar 2025': 160.0,
  };

  String _selectedDate = DateFormat('MMM yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _initializeSelectedDate();
  }

  void _initializeSelectedDate() {
    if (!_monthlyConsumptionData.containsKey(_selectedDate)) {
      _selectedDate = _monthlyConsumptionData.keys.first;
    }
  }

  Future<void> _initializeWebSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final decodedUser = json.decode(userJson) as Map<String, dynamic>;
      final deviceId = decodedUser['uuid']?.toString();
      print('Device ID: $deviceId');
      if (deviceId != null) {
        print('Device ID2: $deviceId');

        _wsService = WebSocketService(deviceId);
        _wsService.connect(
            'http://localhost:3001'); // Replace with your IP if using real device/emulator

        _wsService.sensorStream.listen((data) {
          setState(() {
            flowRate = (data['flowRate'] ?? flowRate).toDouble();
            turbidityLevel = (data['turbidity'] ?? turbidityLevel).toDouble();
            _isConnected = true;
            print('WebSocket data: $data');
          });
        }, onError: (error) {
          setState(() {
            _isConnected = false;
          });
          print('WebSocket error: $error');
        }, onDone: () {
          setState(() {
            _isConnected = false;
          });
          print('WebSocket connection closed');
        });
      }
    }
  }

  @override
  void dispose() {
    _wsService.dispose();
    super.dispose();
  }

  Color _getGaugeColor(double percentage) {
    if (percentage < 0.3) {
      return Colors.green;
    } else if (percentage < 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildCircularGaugeCard(
    BuildContext context,
    String title,
    double value,
    IconData icon,
    Color color,
    String unit,
    double minValue,
    double maxValue,
  ) {
    final percentage =
        ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    final gaugeColor = _getGaugeColor(percentage);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
                      strokeWidth: 8,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF9C27B0).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.calendar_today,
                      size: 24, color: Color(0xFF9C27B0)),
                ),
                SizedBox(height: 8),
                Text(
                  'Monthly Consumption',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                    style: TextStyle(fontSize: 14),
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
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${_monthlyConsumptionData[_selectedDate] ?? 0.0}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                    TextSpan(
                      text: ' liters',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValveControlCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.power_settings_new,
                      size: 24, color: Colors.teal),
                ),
                SizedBox(height: 8),
                Text(
                  'Valve Control',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            _isTogglingValve
                ? CircularProgressIndicator(strokeWidth: 2)
                : Switch(
                    value: _valveStatus,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    onChanged: (value) async {
                      setState(() => _isTogglingValve = true);
                      try {
                        await _apiService.toggleValve(status: value);
                        setState(() => _valveStatus = value);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to toggle valve')),
                        );
                      } finally {
                        setState(() => _isTogglingValve = false);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
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
              if (!_isConnected)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Connecting to sensor data...',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCircularGaugeCard(
                    context,
                    'Flow Rate',
                    flowRate,
                    Icons.water_drop,
                    Color(0xFF00BCD4),
                    'L/min',
                    0,
                    20,
                  ),
                  _buildCircularGaugeCard(
                    context,
                    'Turbidity Level',
                    turbidityLevel,
                    Icons.opacity,
                    Color(0xFFFF9800),
                    'NTU',
                    0,
                    10,
                  ),
                  _buildMonthlyConsumptionCard(),
                  _buildValveControlCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}