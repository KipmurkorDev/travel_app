import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'destination_detail.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationDetail(
              destinationId: widget.destination.destinationId,
            ),
          ),
        );
      },
      child: Center(
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/greencity.webp', // Default local image
                  width: double.infinity,
                  height: 60,
                  fit: BoxFit.cover,
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DestinationDetail(
                          destinationId: widget.destination.destinationId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    minimumSize: const Size(5, 20),
                  ),
                  child: const Text(
                    'More Details',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
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
        await http.get(Uri.parse('http://16.171.145.184/destinations/'));

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
              crossAxisCount: 2,
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
