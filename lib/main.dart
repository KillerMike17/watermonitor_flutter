import 'package:flutter/material.dart';

import 'package:login_ui/pages/Bill/bill_page.dart';

import 'package:login_ui/pages/SupportTicket/ticket_screen.dart';

import 'package:login_ui/pages/home/home_page.dart';

import 'package:login_ui/pages/profile/profile.dart';



void main() {

  runApp(const MaterialApp(

    debugShowCheckedModeBanner: false,

    home: HomePage(),

  ));

}



class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);



  @override

  _HomePageState createState() => _HomePageState();

}



class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0; // Track the selected index



  // List of pages corresponding to each BottomNavigationBarItem

  final List<Widget> _pages = [

    DashboardPage(), // Replace with your actual DashboardPage

    BillingPage(), // Your Billing page

    TicketListPage(), // Your Support Ticket page

    ProfilePage(), // Your Profile page

  ];



  void _onItemTapped(int index) {

    setState(() {

      _selectedIndex = index; // Update the selected index

    });

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: _pages[_selectedIndex], // Display the selected page

      bottomNavigationBar: BottomNavigationBar(

        items: const [

          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),

          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Billing'),

          BottomNavigationBarItem(icon: Icon(Icons.support), label: 'Support Ticket'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        ],

        currentIndex: _selectedIndex, // Set the current index

        onTap: _onItemTapped, // Handle taps

        type: BottomNavigationBarType.fixed,

      ),

    );

  }

}



class HomePageContent extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return Center(child: Text('Dashboard')); // Replace with actual dashboard content

  }

}
