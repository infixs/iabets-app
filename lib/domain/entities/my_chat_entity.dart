import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyChatEntity extends Equatable {
  final String senderName;
  final String senderUID;
  final String recipientName;
  final String recipientUID;
  final String channelId;
  final String profileURL;
  final String recipientPhoneNumber;
  final String senderPhoneNumber;
  final String recentTextMessage;
  final bool isRead;
  final bool isArchived;
  final Timestamp time;
  final String name;

  const MyChatEntity(
      {required this.senderName,
      required this.senderUID,
      required this.recipientName,
      required this.recipientUID,
      required this.channelId,
      required this.profileURL,
      required this.recipientPhoneNumber,
      required this.senderPhoneNumber,
      required this.recentTextMessage,
      required this.isRead,
      required this.isArchived,
      required this.time,
      required this.name});

  @override
  List<Object> get props => [
        senderName,
        senderUID,
        recipientName,
        recipientUID,
        channelId,
        profileURL,
        recipientPhoneNumber,
        senderPhoneNumber,
        recentTextMessage,
        isRead,
        isArchived,
        time,
        name
      ];
}
