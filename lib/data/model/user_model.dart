// user model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

import '../../constants/device_id.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.isOnline,
    required super.uid,
    required super.status,
    required super.profileUrl,
    required super.isAdmin,
    required super.deviceId,
    required super.apiToken,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      uid: data['uid'],
      isOnline: data['isOnline'],
      profileUrl: data['profileUrl'],
      status: data['status'],
      isAdmin: data['isAdmin'],
      deviceId: data['deviceId'] ?? Deviceid.deviceId,
      apiToken: data['apiToken'],
    );
  }

  Map<String, dynamic> toDocument() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "uid": uid,
        "isOnline": isOnline,
        "profileUrl": profileUrl,
        "status": status,
        "isAdmin": isAdmin,
        'deviceId': deviceId,
        'apiToken': apiToken,
      };
}
