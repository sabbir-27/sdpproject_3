// lib/screens/police/police_panel_screen.dart
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'report_screen.dart';
import '../../theme/app_colors.dart';

class PolicePanelScreen extends StatefulWidget {
  const PolicePanelScreen({super.key});

  @override
  State<PolicePanelScreen> createState() => _PolicePanelScreenState();
}

class _PolicePanelScreenState extends State<PolicePanelScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PoliceDashboardScreen(),
    PoliceMapScreen(),
    ReportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accentPolice,
        onTap: _onItemTapped,
      ),
    );
  }
}
