import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:group_chat/DatabaseServices/databaseServiss.dart';
import 'package:group_chat/screen/groupInfo.dart';
import 'package:group_chat/screen/messageTile.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;

  const ChatPage(
      {super.key,
      required this.username,
      required this.groupId,
      required this.groupName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController sendMessageCtrl = TextEditingController();
  // var date = DateTime.now().toString();
  // DateTime objDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date.toString());

  // DateTime StringToDatTimeFormat =
  //     DateFormat('yyyy-MM-dd HH:mm:ss').parse();

  var formatDate = DateFormat("h mm a").format(DateTime.now());
  // String date = DateTime.now().toString();
  // final obj = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);

  // var dateTime = DateFormat('hm').format(obj);
  Stream<QuerySnapshot>? chats;
  String admin = "";
  @override
  void initState() {
    getChatAdmin();
    super.initState();
  }

  getChatAdmin() {
    DataBaseServices().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DataBaseServices().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupInfo(
                              username: widget.username,
                              adminName: admin,
                              groupId: widget.groupId,
                              groupName: widget.groupName)));
                },
                icon: Icon(Icons.info)),
          ],
        ),
        body: Stack(
          children: <Widget>[
            chatMessage(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                color: Colors.grey.shade700,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: sendMessageCtrl,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          hintText: "Send a message...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          suffixIcon: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 213, 196, 246),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                sendMessage();
                              },
                            ),
                          )),
                    ))
                  ],
                ),
              ),
            )
          ],
        ));
  }

  chatMessage() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    log("I am runngin chat page");
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sendByme: widget.username ==
                            snapshot.data.docs[index]['sender'],
                        time: snapshot.data.docs[index]['time'].toString());
                  },
                  // itemCount: 1,
                  itemCount: snapshot.data.docs.length,
                )
              : snapshot.hasError
                  ? Container(
                      child: Center(
                        child: Text("some Error occured"),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    );
        });
  }

  sendMessage() {
    if (sendMessageCtrl.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": sendMessageCtrl.text.trim(),
        "sender": widget.username,
        "time": formatDate,
      };
      DataBaseServices().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        sendMessageCtrl.clear();
      });
    }
  }
}
