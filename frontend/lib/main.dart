import 'package:flutter/material.dart';
import 'destinations.dart';
import 'destination_detail.dart';
import 'wish_list.dart'; // Import the WishlistScreen from wish_list.dart
import 'bookmark_attractions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Destinations App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomPage(),
        '/destinationDetail': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>?;
          final destinationId = arguments?['destinationId'] as String? ?? '';
          return DestinationDetail(destinationId: destinationId);
        },
        '/wishlist': (context) =>
            WishlistScreen(), // Use the imported WishlistScreen
        '/bookmarks': (context) => BookmarkScreen(),
      },
    );
  }
}

class HomPage extends StatefulWidget {
  @override
  _HomPageState createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinations App'),
      ),
      body: const DestinationsList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/wishlist');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/bookmarks');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
