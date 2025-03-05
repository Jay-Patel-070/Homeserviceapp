import 'package:flutter/material.dart';
import 'package:jayshomeserviceapp/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderProfile extends StatefulWidget {
  const ProviderProfile({super.key});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Provider Profile'),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
    );
  }
}
