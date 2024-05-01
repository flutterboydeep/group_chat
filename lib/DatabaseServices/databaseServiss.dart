import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseServices {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  getUserGroup() async {
    return await userCollection.doc(uid).snapshots();
  }

  createGroup(String userName, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupCollection.add({
      "groupName": groupName,
      'groupIcon': "",
      'admin': "${id}_$userName",
      'members': [],
      'groupId': "",
      'recentMessage': "",
      'recentMessageSender': "",
    });
    await groupdocumentReference.update({
      'members': FieldValue.arrayUnion(["${uid}_$userName"]),
      'groupId': groupdocumentReference.id,
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'groups':
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("message")
        .orderBy("time")
        .snapshots();
  }

//   getGroupName(String searchCtrlText) {
//  if() groupCollection.where("groupName", isEqualTo: searchCtrlText).get();

//     DocumentReference userDocumentReference = groupCollection.doc(uid);
//     DocumentSnapshot documentSnapshot = userDocumentReference.get();
//     List<String> groups = documentSnapshot['groupName'];

  //   return groups;
  // }

  getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  getGropMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }
  // is user join group or not

  Future<bool> isUserJoined(
      int index, String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = await userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groupMember = await documentSnapshot['groups'];
    if (groupMember.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = await userCollection.doc(uid);
    DocumentReference groupDocumentReference =
        await groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        'groups': FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      log("I am running in database join button");

      await groupDocumentReference.update({
        'members': FieldValue.arrayUnion(["${uid}_$userName"]),
      });
      await userDocumentReference.update({
        'groups': FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
    }
  }

  // send messag
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) {
    groupCollection.doc(groupId).collection("message").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
