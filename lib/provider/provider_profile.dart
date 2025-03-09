import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jayshomeserviceapp/auth/login_page.dart';
import 'package:jayshomeserviceapp/provider/model/provider.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref().child('Provider');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Provider? _provider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProviderDetails();
  }

  Future<void> _fetchProviderDetails() async {
    try {
      String? userId = _auth.currentUser?.uid; // Get the logged-in provider's UID
      if (userId != null) {
        _database.child(userId).once().then((DatabaseEvent event) {
          DataSnapshot snapshot = event.snapshot;
          if (snapshot.value != null) {
            setState(() {
              _provider = Provider.fromMap(snapshot.value as Map, userId);
              _isLoading = false;
            });
          }
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _logout() async {
    await _auth.signOut(); // Firebase Sign Out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile"),automaticallyImplyLeading: false,),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _provider == null
          ? Center(child: Text("No details found"))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(_provider?.profileImageUrl ??
                      "https://via.placeholder.com/150"), // Default profile pic
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _provider?.firstName ?? "Provider Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                SizedBox(width: 5,),
                Text(
                  _provider?.lastName ?? "Provider Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Email
            Text(
              _provider?.email ?? "provider@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              _provider?.phoneNumber ?? "Phone number",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              _provider?.category ?? "Category",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              _provider?.city ?? "City",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              _provider?.yearsOfExperience.toString() ?? "Experience",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
             ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                onPressed: _logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),)),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
