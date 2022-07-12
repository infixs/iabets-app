// user model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required String name,
      required String email,
      required String phoneNumber,
      required bool isOnline,
      required String uid,
      required String status,
      required String profileUrl,
      required bool isAdmin})
      : super(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            isOnline: isOnline,
            uid: uid,
            status: status,
            profileUrl: profileUrl,
            isAdmin: isAdmin);

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
        name: data['name'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        uid: data['uid'],
        isOnline: data['isOnline'],
        profileUrl: data['profileUrl'],
        status: data['status'],
        isAdmin: data['isAdmin']);
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "isOnline": isOnline,
      "profileUrl": profileUrl,
      "status": status,
      "isAdmin": isAdmin
    };
  }
}
