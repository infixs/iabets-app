import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/aviator_entity.dart';

class AviatorModel extends AviatorEntity {
  AviatorModel(
      {required super.orientationSignal,
      required super.status,
      required super.titleSignal,
      required super.waiting});

  factory AviatorModel.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

    return AviatorModel(
        orientationSignal: json['orientationSignal'],
        status: json['status'],
        titleSignal: json['titleSignal'],
        waiting: json['waiting']);
  }
}
