import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Destination {
  final String id;
  final String name;
  final String description;
  final String image;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['_id'] ?? '',
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<Destination>> wishlistData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    wishlistData = fetchWishlistData();
  }

  Future<List<Destination>> fetchWishlistData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/destinations/wishlist'));
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Destination.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage =
            errorJson['error'] ?? 'Failed to load wishlist data';

        setState(() {
          this.errorMessage = errorMessage;
        });

        return [];
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to connect to the server';
      });
      return [];
    }
  }

  Future<void> removeFromWishlist(String destinationId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/destinations/wishlist/$destinationId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          wishlistData = fetchWishlistData();
        });
      } else {
        throw Exception('Failed to remove from Wishlist');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: FutureBuilder<List<Destination>>(
        future: wishlistData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || errorMessage != null) {
            return Center(
              child: Text('${snapshot.error ?? errorMessage}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your wishlist is empty.'),
            );
          } else {
            final wishlistDestinations = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 10.0), // Add top padding here
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: wishlistDestinations.length,
                itemBuilder: (context, index) {
                  final destination = wishlistDestinations[index];
                  return SizedBox(
                    height: 250, // Set the height of the card here
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            destination.image,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            destination.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            destination.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              removeFromWishlist(destination.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(2.0),
                              minimumSize: const Size(20, 20),
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
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
        currentIndex: 1,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
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
