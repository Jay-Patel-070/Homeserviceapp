import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayshomeserviceapp/chat_screen.dart';
import '../provider/model/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase = FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _providerDatabase = FirebaseDatabase.instance.ref().child('Provider');
  List<Provider> _chatList = [];
  bool _isLoading =  true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchChatList();
  }


  Future<void> _fetchChatList() async {
    String? userId = _auth
        .currentUser?.uid;
    if(userId != null){
      try{
        final DatabaseEvent event = await _chatListDatabase.once();
        DataSnapshot snapshot =event.snapshot;
        List<Provider> tempChatList = [];

        if(snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          for( var providerId in values.keys){
            Map<dynamic, dynamic> userChats = values[providerId];
            if(userChats.containsKey(userId)){
              final DatabaseEvent providerEvent = await _providerDatabase.child(providerId).once();
              DataSnapshot providerSnapshot = providerEvent.snapshot;
              if(providerSnapshot.value != null){
                Provider provider = Provider.fromMap(providerSnapshot.value as Map<dynamic, dynamic>, providerId);
                tempChatList.add(provider);
              }
            }
          }
        }
        setState(() {
          _chatList = tempChatList;
          _isLoading = false;
        });

      }catch (error) {
        // error message
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with'),automaticallyImplyLeading: false,),
      body: _isLoading ? Center(child: CircularProgressIndicator())
          : _chatList.isEmpty
          ? Center(child: Text('No chats available'))
          : ListView.builder(
          itemCount: _chatList.length,
          itemBuilder: (context, index){
            Provider provider = _chatList[index];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(
                  providerId: provider.uid,
                  providerName: '${provider.firstName} ${provider.lastName}',
                  userrrtId: _auth.currentUser!.uid,
                )));
              },
              child: Container(
                  height: 48,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Color(0xffF0EFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xffC8C4FF),
                      )
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 10.0),
                        child: Text('${provider.firstName} ${provider.lastName}',
                          style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w500
                          ),),
                      ),
                    ],
                  )
              ),
            );
          }),
    );
  }
}
