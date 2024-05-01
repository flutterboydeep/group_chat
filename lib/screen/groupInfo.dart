import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:group_chat/DatabaseServices/databaseServiss.dart';

import 'package:group_chat/widgets/popUpDialog.dart';

class GroupInfo extends StatefulWidget {
  final String username;
  final String adminName;
  final String groupId;
  final String groupName;

  const GroupInfo(
      {super.key,
      required this.username,
      required this.adminName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  void initState() {
    getGroupMember();
    super.initState();
  }

  Stream? member;
  getGroupMember() async {
    DataBaseServices().getGropMembers(widget.groupId).then((val) {
      setState(() {
        member = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(widget.groupName, style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
              onPressed: () {
                popDialog(context);
              },
              icon: Icon(Icons.logout_rounded)),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      //
      body: memberList(),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: member,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            const Color.fromARGB(255, 197, 174, 236),
                        child: Text(getName(snapshot.data['members'][index])
                            .toString()
                            .characters
                            .first
                            .toUpperCase()),
                      ),
                      title: Text(
                          getName(snapshot.data['members'][index].toString())),
                      trailing: index == 0
                          ? Text(" Group Admin ",
                              style: TextStyle(
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 246, 187),
                                  fontSize: 15))
                          : SizedBox(),
                    ),
                  );
                },
                itemCount: snapshot.data['members'].length,
              );
            } else {
              return const Center(
                child: Text("No Any group Members"),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("NO Data found"));
          } else {
            return Center(
              child: Text("Some Error occured"),
            );
          }
        });
  }

  popDialog(context) {
    return PopupDialog(
      okkButton: () {
        DataBaseServices()
            .toggleGroupJoin(widget.groupId, widget.username, widget.groupName);
      },
      title: "Group",
      content: Text("Logout form group"),
    ).popdialog(context);
  }
}
