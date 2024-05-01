import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:group_chat/DatabaseServices/databaseServiss.dart';
import 'package:group_chat/bloc/chat_bloc.dart';

import 'package:group_chat/screen/gourpTile.dart';
import 'package:group_chat/screen/login.dart';
import 'package:group_chat/screen/searchPage.dart';

import 'package:group_chat/widgets/button.dart';
import 'package:group_chat/widgets/popUpDialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  State<StatefulWidget> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController addGroupCtrl = TextEditingController();
  var username = "";
  var email = "";
  Stream? group;
  int selected = 1;

  @override
  void initState() {
    gettingUserData();

    super.initState();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    groupList(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: drawerfun(context),
      ),
      body: Container(
        child: groupList(context),
        // child: BlocListener<ChatBloc, ChatState>(
        //   listenWhen: (previous, current) => previous.res != current.res,
        //   listener: (context, state) {
        //     //      BlocListener<ChatBloc, ChatState>(
        //     if (state.res == "logout") {
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) => LoginPage()));
        //     } else {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(content: Text(state.res.toString())));
        //     }
        //   },
        //   child: CustomButton(
        //     onPressed: () {},
        //     text: "Logout",
        //   ),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  drawerfun(context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: DrawerHeader(
              child: Column(children: [
            Icon(
              Icons.account_circle,
              size: 150,
            ),
            Text(username),
            Text(email),
          ])),
        ),
        ListTile(
          selectedColor: Color.fromARGB(255, 184, 13, 159),
          leading: Icon(Icons.person),
          title: Text("Profile"),
          onTap: () {
            drawerListTileClickedItem(1);
          },
        ),
        ListTile(
          leading: Icon(Icons.groups),
          title: Text("Joined Group"),
          onTap: () {
            drawerListTileClickedItem(3);
          },
        ),
        Flexible(child: Container(), flex: 2),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: CustomButton(
              buttonWidth: 150.0,
              text: 'Log out',
              onPressed: () {
                BlocProvider.of<ChatBloc>(context).add(LogoutEvent());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => LoginPage())));
              }),
        ),
      ],
    );
  }

  dialog() {
    return PopupDialog(
      title: "Create you Group",
      content: TextField(
        controller: addGroupCtrl,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7),
          focusColor: Colors.black,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: "Create Group....",
        ),
      ),
      buttonName: "Create",
      okkButton: () async {
        if (addGroupCtrl.text.trim().toString().isNotEmpty) {
          await DataBaseServices().createGroup(
            username,
            FirebaseAuth.instance.currentUser!.uid,
            addGroupCtrl.text.trim().toString(),
          );
          Navigator.of(context).pop();
        }
      },
    ).popdialog(context);
  }
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Create Group"),
  //           backgroundColor: Color.fromARGB(255, 246, 216, 252),
  //           content:
  //           actions: [
  //             CustomButton(
  //                 text: "Cancel",
  //                 backgroundColor: Colors.red.shade100,
  //                 buttonWidth: 100,
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 }),
  //             CustomButton(
  //                 text: "Create",
  //                 backgroundColor: const Color.fromARGB(255, 185, 242, 187),
  //                 buttonWidth: 100,
  //                 onPressed: () async {

  //           ],
  //         );
  //       });

  gettingUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    username = sp.get("userName").toString();
    email = sp.get("email").toString();
    setState(() {});
    //here value get form shared prefferences

    await DataBaseServices().getUserGroup().then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  groupList(context) {
    return StreamBuilder(
        stream: group,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null ||
                snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  int reverseIdx = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      username: snapshot.data['username'],
                      groupId: getId(snapshot.data['groups'][reverseIdx]),
                      groupName: getName(snapshot.data['groups'][reverseIdx]));
                },
                itemCount: snapshot.data['groups'].length,
              );
            } else {
              return notJoinGroup(context);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("In StreamBuilder has error"),
            );
          }
          return Center(
            child: Text("another error"),
          );
        }));
  }

  notJoinGroup(context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  dialog();
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 120,
                )),
            Text(
              "Click on Button to create a group",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  drawerListTileClickedItem(value) {
    setState(() {
      selected = value;
    });
  }
}
