import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderDataModel {
  final String? id;
  final String name;
  final String contact;

  ServiceProviderDataModel(
      {this.id,
        required this.name,
        required this.contact,
});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
    };
  }

  ServiceProviderDataModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
      contact = doc.data()!["contact"];
}