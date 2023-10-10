import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Attraction {
  final String id;
  final String name;
  final String description;
  final String image;

  Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['_id'] ?? '',
      name: json['name'],
      description: json['description'],
      image: json['image'], // Parse the image URL
    );
  }
}

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<Attraction>> bookmarkedAttractions;
  String? errorMessage; // Store error message in the state

  @override
  void initState() {
    super.initState();
    bookmarkedAttractions = fetchBookmarkedAttractions();
  }

  Future<List<Attraction>> fetchBookmarkedAttractions() async {
    try {
      final response = await http.get(Uri.parse(
          'http://16.171.145.184/destinations/bookmarked-attractions'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Attraction.fromJson(json)).toList();
      } else {
        // Check if the response contains JSON data with an "error" key
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage =
            errorJson['error'] ?? 'Failed to load bookmarked attractions data';

        setState(() {
          this.errorMessage =
              errorMessage; // Set the error message in the state
        });

        return []; // Return an empty list when there's an error
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to connect to the server'; // Handle network errors
      });
      return []; // Return an empty list when there's an error
    }
  }

  // Function to remove an item from bookmarks
  Future<void> removeFromBookmarks(String attractionId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://16.171.145.184/destinations/bookmark/$attractionId'),
      );
      if (response.statusCode == 200) {
        // Reload bookmarks data after a successful deletion
        setState(() {
          bookmarkedAttractions = fetchBookmarkedAttractions();
        });
      } else {
        throw Exception('Failed to remove from Bookmarks');
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error, e.g., show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'), // Title for the BookmarkScreen
      ),
      body: errorMessage != null
          ? buildErrorWidget(
              context) // Display error widget if errorMessage is not null
          : Padding(
              padding: const EdgeInsets.only(top: 16.0), // Add top padding here
              child: FutureBuilder<List<Attraction>>(
                future: bookmarkedAttractions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return buildErrorWidget(
                        context); // Display error widget on error
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No bookmarked attractions.'),
                    );
                  } else {
                    final bookmarkedAttractions = snapshot.data!;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: bookmarkedAttractions.length,
                      itemBuilder: (context, index) {
                        final attraction = bookmarkedAttractions[index];
                        return Card(
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                attraction.image,
                                height: 100, // Adjust the height as needed
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Text(attraction.name),
                              Text(attraction.description),
                              ElevatedButton(
                                onPressed: () {
                                  removeFromBookmarks(attraction.id);
                                },
                                child: Text('Remove'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
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
        currentIndex: 2, // Set the current index to 2 for the Bookmarks icon
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/wishlist');
              break;
            case 2:
              // Do nothing if the Bookmarks icon is tapped (already on Bookmarks screen)
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Widget buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Error:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'An error occurred',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
