import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayshomeserviceapp/provider/model/provider.dart';

class ProviderCard extends StatelessWidget {
  final Provider provider;

  const ProviderCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xffF0EFFF),
        border: Border.all(color: Color(0xffC8C4FF)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: Color(0xffF0EFFF),
        elevation: 0.0,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: ListTile(
          leading: Container(
            width: 55,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: Color(0xff0064FA)),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(provider.profileImageUrl),
            ),
          ),
          title: Text(
            '${provider.firstName} ${provider.lastName}',
            style: GoogleFonts.poppins(
              fontSize: 15, fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(children: [
                Text('${provider.category} - ${provider.city}',
                  style: GoogleFonts.poppins(
                      fontSize: 13
                  ),)
              ],),
              Text(
                'Experience: ${provider.yearsOfExperience} years',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Color(0xffFA9600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
