import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/crash_entity.dart';

class CrashModel extends CrashEntity {
  CrashModel(
      {required super.orientationSignal,
      required super.status,
      required super.titleSignal,
      required super.waiting});

  factory CrashModel.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

    return CrashModel(
        orientationSignal: json['orientationSignal'],
        status: json['status'],
        titleSignal: json['titleSignal'],
        waiting: json['waiting']);
  }
}
