import 'package:flutter/material.dart';
import 'package:group_chat/screen/chatpage.dart';

class GroupTile extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;

  const GroupTile(
      {super.key,
      required this.username,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 197, 174, 236),
          child: Text(widget.groupName.substring(0, 1).toUpperCase().trim()),
        ),
        title: Text(widget.groupName),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        username: widget.username,
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                      )));
        },
      ),
    );
  }
}
