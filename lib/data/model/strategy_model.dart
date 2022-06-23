import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/strategy_entity.dart';

class StrategyModel extends StrategyEntity {
  StrategyModel({required String name, required String id})
      : super(name: name, id: id);

  factory StrategyModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return StrategyModel(id: snapshot.id, name: data['name']);
  }
}
