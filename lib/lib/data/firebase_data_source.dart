import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(String name, String phone) async {
    try {
      var userRef = db.collection("users");
      var docId = await checkUserExist(name, phone, userRef);
      if (docId != "") {
        return docId;
      } else {
        var result = await userRef.add({'name': name, 'contact': phone,"roomId":""});
        if (result.id != '') {
          return result.id;
        } else {
          throw Exception("Something went wrong");
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> checkUserExist(
    String name,
    String phone,
    CollectionReference<Map<String, dynamic>> userRef,
  ) async {
    var docId = "";
    var snapshot = await userRef.get();
    snapshot.docs.forEach((doc) {
      if (name == doc["name"]) {
        docId = doc.id;
      } else {
        docId = "";
      }
    });
    return docId;
  }

  void updateRoomToUser({required String senderId, String? receiverId, String? roomId}) {
    final userRef = db.collection('users').doc(senderId);
    userRef.update({
      "roomId": roomId,
      "caller": true,
      "callee":false
    });
    final userRef2 = db.collection('users').doc(receiverId);
    userRef2.update({"roomId": roomId,
      "caller": false,
      "callee":true
    });
  }


  void clearOnHangUp({String? senderId, String? receiverId, String? roomId}){
    final userRef = db.collection('users').doc(senderId);

    userRef.update({
      "roomId": '',
      "caller": false,
      "callee":false
    });
    final userRef2 = db.collection('users').doc(receiverId);
    userRef2.update({"roomId": '',
      "caller": false,
      "callee":false
    });
  }


}
