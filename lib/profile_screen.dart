import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'registration_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _profilePictureUrl;
  String _routePoints = "250";
  String? _userId; // To store the unique userId

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  /// Fetch userId from Firestore
  Future<void> _loadUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _userId = snapshot['userId'] ?? 'N/A';
        });
      } else {
        setState(() {
          _userId = 'Not Found';
        });
      }
    }
  }

  // Change password function
  Future<void> _changePassword() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If no user is logged in
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No user logged in')));
      return;
    }

    try {
      // Send a password reset email to the user
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password reset email sent!')));
    } catch (e) {
      // If there's an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending password reset email: $e')),
      );
    }
  }

  // Edit profile function
  Future<void> _editProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If no user is logged in
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No user logged in')));
      return;
    }

    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    nameController.text =
        user.displayName ?? ''; // Pre-populate with the current name
    emailController.text =
        user.email ?? ''; // Pre-populate with the current email

    // Display dialog for name and email edit
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  // Update name if changed
                  if (nameController.text.isNotEmpty) {
                    await user.updateProfile(displayName: nameController.text);
                  }

                  // Update email if changed
                  if (emailController.text.isNotEmpty &&
                      emailController.text != user.email) {
                    await user.updateEmail(emailController.text);
                  }

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully')),
                  );
                  Navigator.of(context).pop(); // Close dialog
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating profile: $e')),
                  );
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Close dialog without saving
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickProfilePicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;
      });
    }
  }

  // Existing _editProfile() and _changePassword() remain unchanged

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Welcome, ${user?.email ?? 'Guest'}',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text('Routes'),
              onTap: () {
                Navigator.pushNamed(context, '/routes');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _profilePictureUrl != null
                    ? FileImage(File(_profilePictureUrl!))
                    : null,
                child: _profilePictureUrl == null
                    ? Icon(Icons.camera_alt, color: Colors.white, size: 30)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // Email
            Text('Email: ${user?.email ?? 'No user'}'),
            SizedBox(height: 10),

            // User ID
            // Text(
            //   'User ID: ${_userId ?? "Loading..."}',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 20),

            // Dashboard for Route Points
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text('Current Route Points', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text(
                    _routePoints,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value:
                        double.parse(_routePoints) /
                        1000, // Example value to represent progress
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: _editProfile,
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 10),

            // Change Password Button
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ), // Existing route points dashboard remains unchanged
          ],
        ),
      ),
    );
  }
}
