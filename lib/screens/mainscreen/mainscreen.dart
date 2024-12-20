import 'package:flutter/material.dart';
import 'package:brainys/screens/authentication/login_page.dart';
import 'package:brainys/screens/authentication/profile_page.dart';
import 'package:brainys/screens/authentication/register_page.dart';
import 'package:brainys/screens/authentication/splash.dart';
import 'package:brainys/screens/mainscreen/history_page.dart';
import 'package:brainys/screens/mainscreen/home_page.dart';
import 'package:brainys/screens/mainscreen/profile_page.dart';
import 'package:brainys/screens/mainscreen/subscription_page.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final int initialTabIndex;

  const MainScreen({Key? key, this.initialIndex = 0, this.initialTabIndex = 0})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomePage(),
      SubscriptionPage(),
      HistoryPage(),
      DetailProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[900],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                color: _currentIndex == 0 ? Colors.blue[900] : Colors.grey,
                size: 24,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Icon(
                _currentIndex == 1
                    ? Icons.subscriptions
                    : Icons.subscriptions_outlined,
                color: _currentIndex == 1 ? Colors.blue[900] : Colors.grey,
                size: 24,
              ),
            ),
            label: 'Subscription',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Icon(
                _currentIndex == 2 ? Icons.history : Icons.history_outlined,
                color: _currentIndex == 2 ? Colors.blue[900] : Colors.grey,
                size: 24,
              ),
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Icon(
                _currentIndex == 3 ? Icons.person : Icons.person_outline,
                color: _currentIndex == 3 ? Colors.blue[900] : Colors.grey,
                size: 24,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
