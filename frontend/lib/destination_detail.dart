import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DestinationDetail extends StatefulWidget {
  final String destinationId;

  const DestinationDetail({required this.destinationId});

  @override
  _DestinationDetailState createState() => _DestinationDetailState();
}

class Attraction {
  final String id;
  final String name;
  final String description;
  final String image; // Add image URL attribute

  Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image:
          json['image'] ?? '', // Replace 'image' with the actual attribute name
    );
  }
}

class Destination {
  final String destinationId;
  final String name;
  final String description;
  final List<Attraction> attractions;

  Destination({
    required this.destinationId,
    required this.name,
    required this.description,
    required this.attractions,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    final List<dynamic> attractionsJson = json['attractions'] ?? [];
    final List<Attraction> attractions = attractionsJson
        .map((attraction) => Attraction.fromJson(attraction))
        .toList();

    return Destination(
      destinationId: json['_id'] ?? '',
      name: json['name'],
      description: json['description'],
      attractions: attractions,
    );
  }
}

class _DestinationDetailState extends State<DestinationDetail> {
  Destination? destination;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDestinationDetails();
  }

  Future<void> fetchDestinationDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://16.171.145.184/destinations/${widget.destinationId}'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          destination = Destination.fromJson(jsonData);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load destination details');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addToWishlist(String destinationId) async {
    try {
      final response = await http.patch(
        Uri.parse('http://16.171.145.184/destinations/wishlist/$destinationId'),
      );
      if (response.statusCode == 200) {
        print('Added to Wishlist');
      } else {
        throw Exception('Failed to add to Wishlist');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> addBookmark(String destinationId, String attractionId) async {
    try {
      final response = await http.patch(
        Uri.parse(
            'http://16.171.145.184/destinations/bookmark/$destinationId/$attractionId/'),
      );
      if (response.statusCode == 200) {
        print('Added to Bookmarks');
      } else {
        throw Exception('Failed to add to Bookmarks');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // Placeholder function for loading images, replace with actual image loading logic
  Widget _loadImage(String imageUrl) {
    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            width: 100, // Adjust width and height as needed.
            height: 90,
            fit: BoxFit.cover,
          )
        : const SizedBox
            .shrink(); // If no image URL is provided, return an empty SizedBox.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destination Detail'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : destination != null
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            destination!.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            destination!.description,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (destination!.attractions.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Places you can visit at ${destination!.name}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Display two items per row
                              ),
                              itemCount: destination!.attractions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final attraction =
                                    destination!.attractions[index];
                                return Card(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _loadImage(attraction.image),
                                        Text(
                                          attraction.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          attraction.description,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        // Load the image here
                                        ElevatedButton(
                                          onPressed: () {
                                            addBookmark(widget.destinationId,
                                                attraction.id);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(2.0),
                                            minimumSize: const Size(30, 20),
                                          ),
                                          child: const Text('Bookmark'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ElevatedButton(
                        onPressed: () {
                          addToWishlist(widget.destinationId);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(2.0),
                          minimumSize: const Size(20, 20),
                        ),
                        child: const Text('Add to Wishlist'),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text('Destination not found.'),
                ),
    );
  }
}
