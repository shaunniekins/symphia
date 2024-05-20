// user_profile.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final DateTime birthday;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.uid,
    required this.name,
    required this.birthday,
    this.preferences = const {},
  });

  // Named constructor to create a UserProfile instance from a map
  UserProfile.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        name = map['name'],
        birthday = DateTime(
            (map['birthday'] as Timestamp).toDate().year,
            (map['birthday'] as Timestamp).toDate().month,
            (map['birthday'] as Timestamp).toDate().day),
        preferences = map['preferences'] != null
            ? Map<String, dynamic>.from(map['preferences'])
            : {};

  // Method to convert a UserProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'birthday': DateTime(birthday.year, birthday.month, birthday.day),
      'preferences': preferences,
    };
  }
}
