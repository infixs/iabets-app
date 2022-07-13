import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String deviceId;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isOnline;
  final String uid;
  final String status;
  final String profileUrl;
  final bool isAdmin;

  const UserEntity(
      {required this.name,
      required this.deviceId,
      required this.email,
      required this.phoneNumber,
      required this.isOnline,
      required this.uid,
      this.status = "Hey there! I am Using WhatsApp Clone.",
      required this.profileUrl,
      required this.isAdmin});

  @override
  List<Object> get props =>
      [name, email, phoneNumber, isOnline, uid, status, profileUrl, isAdmin];
}
