import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jayshomeserviceapp/chat_screen.dart';
import 'package:jayshomeserviceapp/provider/model/user.dart';

class ProviderChatlistPage extends StatefulWidget {
  const ProviderChatlistPage({super.key});

  @override
  State<ProviderChatlistPage> createState() => _ProviderChatlistPageState();
}

class _ProviderChatlistPageState extends State<ProviderChatlistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase = FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _userDatabase = FirebaseDatabase.instance.ref().child('User');
  List<Userrrrr> _chatList = [];
  bool _isLoading =  true;
  late String providerId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerId = _auth.currentUser?.uid ?? '';
    _fetchChatList();
  }


  Future<void> _fetchChatList() async {
    if(providerId.isNotEmpty){
      try{
        final DatabaseEvent event = await _chatListDatabase.child(providerId).once();
        DataSnapshot snapshot = event.snapshot;
        List<Userrrrr> tempChatList = [];

        if(snapshot.value != null){
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

          for( var userId in values.keys){
            final DatabaseEvent userEvent = await _userDatabase.child(userId).once();
            DataSnapshot userSnapshot = userEvent.snapshot;
            if(userSnapshot.value != null){
              Map<dynamic, dynamic> userMap = userSnapshot.value as Map<dynamic, dynamic>;
              tempChatList.add(Userrrrr.fromMap(Map<String, dynamic>.from(userMap)));
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
            final userrr = _chatList[index];
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text('Chat with ${userrr.firstName} ${userrr.lastName}'),
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            providerId:  providerId,
                            userrrtId: userrr.uid,
                            userName: '${userrr.firstName} ${userrr.lastName}',
                          )
                      )
                  );
                },
              ),
            );
          }),
    );
  }
}
