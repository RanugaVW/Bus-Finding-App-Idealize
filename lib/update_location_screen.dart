import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateLocationScreen extends StatefulWidget {
  @override
  _UpdateLocationScreenState createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _busRouteController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updateLocation() async {
    if (_locationController.text.isEmpty || _busRouteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location and Bus Route are required!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String routeId = _busRouteController.text.trim();
      String busNumber = _busNumberController.text.trim();
      String location = _locationController.text.trim();

      final routeRef = FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId);

      final snapshot = await routeRef.get();

      if (snapshot.exists) {
        // Append update to existing route
        await routeRef.update({
          'updates': FieldValue.arrayUnion([
            {
              'busNumber': busNumber.isNotEmpty ? busNumber : "N/A",
              'location': location,
              'updatedAt': DateTime.now(),
            },
          ]),
        });
      } else {
        // Create a new route document
        await routeRef.set({
          'busRoute': routeId,
          'updates': [
            {
              'busNumber': busNumber.isNotEmpty ? busNumber : "N/A",
              'location': location,
              'updatedAt': DateTime.now(),
            },
          ],
        });
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Location updated successfully!')));

      _locationController.clear();
      _busNumberController.clear();
      _busRouteController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating location: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Bus Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _busRouteController,
              decoration: InputDecoration(labelText: "Bus Route (e.g., A)"),
            ),
            TextField(
              controller: _busNumberController,
              decoration: InputDecoration(labelText: "Bus Number (Optional)"),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Current Location"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateLocation,
                    child: Text("Update Location"),
                  ),
          ],
        ),
      ),
    );
  }
}
