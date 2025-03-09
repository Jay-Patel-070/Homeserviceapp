import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jayshomeserviceapp/auth/login_page.dart';
import 'package:jayshomeserviceapp/provider/model/user.dart'; // Correct import

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref().child('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Userrrrr? _user; // Changed from Userrrrr to UserModel
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      String? userId = _auth.currentUser?.uid; // Get the logged-in provider's UID
      if (userId != null) {
        _database.child(userId).once().then((DatabaseEvent event) {
          DataSnapshot snapshot = event.snapshot;
          if (snapshot.value != null) {
            setState(() {
              _user = Userrrrr.fromMap((snapshot.value as Map).cast<String, dynamic>());
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
      appBar: AppBar(
        title: Text("My Profile"),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
          ? Center(child: Text("No details found"))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_user?.profileImageUrl ??
                    "https://via.placeholder.com/150"), // Default profile pic
              ),
              SizedBox(height: 16),

              // Name
              Text(
                "${_user?.firstName ?? "First"} ${_user?.lastName ?? "Last"}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Email
              Text(
                _user?.email ?? "User@example.com",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              // Email
              Text(
                _user?.phoneNumber ?? "phone number",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              // Logout Button
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
