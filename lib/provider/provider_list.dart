import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayshomeserviceapp/provider/provider_details_page.dart';
import 'package:jayshomeserviceapp/provider/model/provider.dart';
import 'package:jayshomeserviceapp/provider/widget/provider_card.dart';

class ProviderListPage extends StatefulWidget {
  const ProviderListPage({super.key});

  @override
  State<ProviderListPage> createState() => _ProviderListPageState();
}

class _ProviderListPageState extends State<ProviderListPage> {
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref().child('Provider');
  List<Provider> _providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    try {
      await _database.once().then((DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;
        List<Provider> tmpProvider = [];
        if (snapshot.value != null) {
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            Provider provider = Provider.fromMap(value, key);
            tmpProvider.add(provider);
          });
        }
        setState(() {
          _providers = tmpProvider;
          _isLoading = false;
        });
      });
    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Find your service,\nand book an service',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProviderDetailPage(provider: _providers[index]),
                          ),
                        );
                      },
                      child: ProviderCard(provider: _providers[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
