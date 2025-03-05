import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayshomeserviceapp/auth/login_page.dart';
import 'package:jayshomeserviceapp/provider/provider_home_page.dart';
import 'package:jayshomeserviceapp/user/user_home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    User? user = _auth.currentUser;

    if (user == null) {
      await Future.delayed(Duration(seconds: 2));
      _navigateToLogin();
    } else {
      DatabaseReference userRef = _database.child('Provider').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        await Future.delayed(Duration(seconds: 2));
        _navigateToProviderHome();
      } else {
        userRef = _database.child('User').child(user.uid);
        snapshot = await userRef.get();
        if (snapshot.exists) {
          await Future.delayed(Duration(seconds: 2));
          _navigateToUserHome();
        } else {
          await Future.delayed(Duration(seconds: 2));
          _navigateToLogin();
        }
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _navigateToProviderHome() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProviderHomePage()));
  }

  void _navigateToUserHome() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff0064FA),
        child: Center(child: Image.asset('assets/images/splashimage.png', width: MediaQuery.of(context).size.width,)),
      ),
    );
  }

}
