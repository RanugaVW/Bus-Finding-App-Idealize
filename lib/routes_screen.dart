import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Routes')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Route A'),
            onTap: () {
              // Navigate to detailed route or show route info
            },
          ),
          ListTile(
            title: Text('Route B'),
            onTap: () {
              // Navigate to detailed route or show route info
            },
          ),
          ListTile(
            title: Text('Route C'),
            onTap: () {
              // Navigate to detailed route or show route info
            },
          ),
        ],
      ),
    );
  }
}
