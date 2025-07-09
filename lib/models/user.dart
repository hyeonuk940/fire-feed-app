import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String emailID;
  final String name;
  final int age;
  final DateTime joinDate;

  AppUser({
    required this.uid,
    required this.emailID,
    required this.name,
    required this.age,
    required this.joinDate,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      emailID: json['emailID'],
      name: json['name'],
      age: json['age'],
      joinDate: json['joinDate'] is DateTime
          ? json['joinDate']
          : (json['joinDate'] is Timestamp
          ? (json['joinDate'] as Timestamp).toDate()
          : DateTime.parse(json['joinDate'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'emailID': emailID,
      'name': name,
      'age': age,
      'joinDate': joinDate,
    };
  }
}
