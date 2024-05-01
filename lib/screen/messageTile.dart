import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByme;
  final String time;
  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sendByme,
      required this.time});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 2, left: 10, right: 10),
      child: Container(
        alignment:
            widget.sendByme ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          // alignment:
          //     widget.sendByme ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight:
                  widget.sendByme ? Radius.circular(0) : Radius.circular(20),
              bottomLeft:
                  widget.sendByme ? Radius.circular(20) : Radius.circular(0),
            ),
            color: widget.sendByme
                ? const Color.fromARGB(255, 221, 206, 250)
                : const Color.fromARGB(255, 176, 176, 176),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 2.0, bottom: 2, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sender,
                      style: TextStyle(
                          color: widget.sendByme
                              ? Color.fromARGB(255, 127, 57, 57)
                              : Color.fromARGB(255, 52, 148, 76),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(widget.message),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     SizedBox(
                    //       child: Text("h"),
                    //       // height: 1,
                    //     ),
                    // Align(
                    // alignment: Alignment.centerRight,

                    // ),
                    //   ],
                    // ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.time,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
