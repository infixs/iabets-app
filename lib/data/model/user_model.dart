// user model

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.name,
      required super.email,
      required super.phoneNumber,
      required super.isOnline,
      required super.uid,
      required super.status,
      required super.profileUrl,
      required super.isAdmin,
      required super.deviceId});

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
      deviceId: data['deviceId'],
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
        'deviceId': deviceId
      };

  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    return (await deviceInfoPlugin.deviceInfo).toMap()['id'];
  }
}
