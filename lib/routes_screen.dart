import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Routes')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('routes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No routes updated yet."));
          }

          final routes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final routeData = routes[index].data() as Map<String, dynamic>;
              final updates = routeData['updates'] as List<dynamic>? ?? [];

              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text('Route: ${routeData['busRoute']}'),
                  children: updates.map((update) {
                    return ListTile(
                      title: Text("Bus: ${update['busNumber']}"),
                      subtitle: Text(
                        "Location: ${update['location']}\nUpdated: ${update['updatedAt'].toDate()}",
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
