import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TextMessageEntity extends Equatable {
  final String senderName;
  final String sederUID;
  final String recipientName;
  final String recipientUID;
  final String messsageType;
  final String message;
  final String messageId;
  final Timestamp time;

  TextMessageEntity({
    required this.senderName,
    required this.sederUID,
    required this.recipientName,
    required this.recipientUID,
    required this.messsageType,
    required this.message,
    required this.messageId,
    required this.time,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
    senderName,
    sederUID,
    recipientName,
    recipientUID,
    messsageType,
    message,
    messageId,
    time,
  ];
}
