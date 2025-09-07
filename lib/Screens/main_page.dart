import 'package:flutter/material.dart';
import 'package:multi_api_flutter_app/Screens/Movie_page.dart';
import 'package:multi_api_flutter_app/Screens/crypto_page.dart';
import 'package:multi_api_flutter_app/Screens/news_page.dart';
import 'package:multi_api_flutter_app/Screens/qoute_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MovieScreen(),
    const CryptoScreen(),
    const NewsScreen(),
    QuoteJokeScreen(),
  ];

  final List<String> _titles = [
    'Movies',
    'Crypto Tracker',
    'Latest News',
    'Quotes & Jokes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        elevation: 0,
        backgroundColor: _getAppBarColor(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: _getAppBarColor(),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Crypto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Quotes',
          ),
        ],
      ),
    );
  }

  Color _getAppBarColor() {
    switch (_currentIndex) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.tealAccent;
      default:
        return Colors.blue;
    }
  }
}
