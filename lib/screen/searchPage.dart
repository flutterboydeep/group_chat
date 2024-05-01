import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/DatabaseServices/databaseServiss.dart';
import 'package:group_chat/bloc/chat_bloc.dart';
import 'package:group_chat/screen/chatpage.dart';
import 'package:group_chat/screen/groupInfo.dart';
import 'package:group_chat/widgets/button.dart';
import 'package:group_chat/widgets/wTextFiled.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchCtrl = TextEditingController();
  bool isSerching = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoinedGroup = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userName = sp.get("userName").toString();
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Search"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextFieldWidget(
              filled: true,
              hintText: "Search groups...",
              textInputType: TextInputType.name,
              textEditingController: searchCtrl,
              suffixWidget: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    initiateSearchMethod();
                  }),
            ),
          ),
        ),
        actions: [],
      ),
      body: isSerching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SerchingGroupList(),
    );
  }

  initiateSearchMethod() async {
    if (searchCtrl.text.isNotEmpty) {
      setState(() {
        isSerching = true;
      });
      await DataBaseServices()
          .searchByName(searchCtrl.text.trim())
          .then((snap) {
        setState(() {
          searchSnapshot = snap;
          isSerching = false;
          hasUserSearched = true;
        });
      });
    }
  }

  SerchingGroupList() {
    // List<String> groupName =  DataBaseServices().getGroupName();
    return hasUserSearched == true
        // ? !groupName.contains(searchCtrl.text.trim())
        // ? Center(
        //     child: Text(
        //       "NO Group found",
        //       style: TextStyle(fontSize: 35, color: Colors.red),
        //     ),
        //   )
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                index,
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
            itemCount: searchSnapshot!.docs.length,
          )
        : SizedBox();
  }

  searchTile(int index, String userName, String searchgroupId, String groupName,
      String admin) {
    joinGroupOrnot(index, userName, searchgroupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: const Color.fromARGB(255, 197, 174, 236),
        child: Text(groupName.characters.first.toUpperCase()),
      ),
      title: Text(groupName),
      subtitle: Text("admin: ${getName(admin)}"),
      trailing: isJoinedGroup
          ? CustomButton(
              onPressed: () async {
                await joinUserFun(userName, searchgroupId, groupName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ChatPage(
                          username: userName,
                          groupId: searchgroupId,
                          groupName: groupName))),
                );
              },
              text: "Joined",
              buttonWidth: 100,
              backgroundColor: Color.fromARGB(255, 109, 225, 165))
          : CustomButton(
              onPressed: () async {
                await joinUserFun(userName, searchgroupId, groupName);
              },
              text: "Join",
              buttonWidth: 80,
              backgroundColor: Colors.deepPurple.shade200),
    );

    // return Center(child: Text("found"));
  }

  joinGroupOrnot(int index, String userName, String groupId, String groupName,
      String admin) async {
    await DataBaseServices()
        .isUserJoined(index, groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoinedGroup = value;
      });
      log("The value of isJoinedGroup in serchbar is $value");
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  joinUserFun(String userName, String groupId, String groupName) async {
    await DataBaseServices().toggleGroupJoin(groupId, userName, groupName);
    if (isJoinedGroup == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully join Group"),
        backgroundColor: const Color.fromARGB(255, 57, 169, 61),
      ));
      setState(() {
        isJoinedGroup = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully Exit from Group"),
        backgroundColor: Colors.red.shade200,
      ));
      setState(() {
        isJoinedGroup = true;
      });
    }
  }
}
