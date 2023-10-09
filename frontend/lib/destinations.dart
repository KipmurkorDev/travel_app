import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'destination_detail.dart'; // Import the DestinationDetail page

class Destination {
  final String destinationId;
  final String name;
  final String description;
  final String imageUrl;

  const Destination({
    required this.destinationId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      destinationId: json['_id'] ?? '',
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'], // Update to use "image" as the key
    );
  }
}

class DestinationCard extends StatefulWidget {
  final Destination destination;

  const DestinationCard({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  _DestinationCardState createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          // Navigate to the DestinationDetail page with destinationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DestinationDetail(
                destinationId: widget.destination.destinationId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0), // Add padding to the top
          child: SizedBox(
            height:
                isHovered ? 550 : 500, // Adjust the size based on hover state
            child: Card(
              elevation: isHovered
                  ? 4.0
                  : 2.0, // Adjust elevation based on hover state
              child: Padding(
                padding:
                    const EdgeInsets.all(8.0), // Padding for the Card's content
                child: Column(
                  children: [
                    if (widget.destination.imageUrl.isNotEmpty)
                      Image.network(
                        widget.destination.imageUrl,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    else
                      const SizedBox(
                        width: 30,
                        height: 40,
                        child: Icon(Icons.image_not_supported),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.destination.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.destination.description,
                        style: const TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DestinationsList extends StatelessWidget {
  final Key? key;
  const DestinationsList({this.key}) : super(key: key);

  Future<List<Destination>> fetchDestinations() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/destinations/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Destination.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Destination>>(
      future: fetchDestinations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final destinations = snapshot.data;
          if (destinations == null || destinations.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Display three items per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: destinations.length,
            itemBuilder: (BuildContext context, int index) {
              final destination = destinations[index];
              return DestinationCard(destination: destination);
            },
          );
        }
      },
    );
  }
}
