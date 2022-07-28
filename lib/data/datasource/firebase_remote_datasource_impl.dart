//api firebase
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ia_bet/data/datasource/firebase_remote_datasource.dart';
import 'package:ia_bet/data/model/crash_model.dart';
import 'package:ia_bet/data/model/double_config_model.dart';
import 'package:ia_bet/data/model/my_chat_model.dart';
import 'package:ia_bet/data/model/strategy_model.dart';
import 'package:ia_bet/data/model/text_message_model.dart';
import 'package:ia_bet/data/model/user_model.dart';
import 'package:ia_bet/domain/entities/crash_entity.dart';
import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

import '../../constants/device_id.dart';
import '../../domain/entities/strategy_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  final FirebaseFunctions fireFunctions;

  String _verificationId = "";

  FirebaseRemoteDataSourceImpl(
      {required this.auth,
      required this.fireStore,
      required this.fireFunctions});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUID();
    await userCollection.doc(uid).get().then((userDoc) async {
      final newUser = UserModel(
        status: user.status,
        profileUrl: user.profileUrl,
        isOnline: user.isOnline,
        uid: uid,
        phoneNumber: user.phoneNumber,
        email: user.email,
        name: user.name,
        isAdmin: user.isAdmin,
        deviceId: Deviceid.deviceId,
        apiToken: user.apiToken,
      ).toDocument();
      if (!userDoc.exists) {
        //create new user
        userCollection.doc(uid).set(newUser);
      } else {
        //update user doc
        userCollection.doc(uid).update(newUser);
      }
    });
  }

  @override
  Future<void> setDeviceidToken() async {
    final uid = await getCurrentUID();
    final DocumentReference docRef = fireStore.collection("users").doc(uid);

    docRef.update({'deviceId': Deviceid.deviceId});
  }

  @override
  Future<String> getCurrentUID() async => auth.currentUser!.uid;

  @override
  Stream<UserEntity> getCurrentUser() {
    final userCollection = fireStore.collection("users");
    if (auth.currentUser == null) {
      throw Exception('User not logged');
    }
    final uid = auth.currentUser?.uid;
    return userCollection.doc(uid).snapshots().map((snapshot) {
      return UserModel.fromSnapshot(snapshot);
    });
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser != null ? true : false;

  @override
  Future<void> setUserToken(String token) async {
    final userCollection = fireStore.collection("users");
    final uid = auth.currentUser?.uid;
    if (uid != null) {
      await userCollection.doc(uid).update({'token': token});
    }
  }

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsPinCode);
    await auth.signInWithCredential(authCredential);
  }

  @override
  Future<void> sendPushMessage(
      String channelId, String title, String message) async {
    final HttpsCallable callable = fireFunctions.httpsCallable('sendMessage');
    final resp = callable.call(<String, dynamic>{
      'channelId': channelId,
      'channelName': title,
      'message': message
    });
    debugPrint(resp.toString());
  }

  @override
  Future<void> signOut() async => await auth.signOut();

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    debugPrint(email);

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());

      if (e.code == 'user-not-found') {
        try {
          try {
            await auth.createUserWithEmailAndPassword(
                email: email, password: password);
          } on FirebaseAuthException catch (e) {
            debugPrint(e.toString());
            return;
          }
        } catch (e) {
          return;
        }
      }
    }
  }

  void phoneVerificationCompleted(AuthCredential authCredential) {
    debugPrint("phone verified : Token ${authCredential.token}");
  }

  void phoneVerificationFailed(FirebaseAuthException firebaseAuthException) {
    debugPrint(
      "phone failed : ${firebaseAuthException.message},${firebaseAuthException.code}",
    );
  }

  void phoneCodeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
    debugPrint("time out :$verificationId");
  }

  void phoneCodeSent(String verificationId, [int? forceResendingToken]) {}

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      timeout: const Duration(seconds: 10),
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );
  }

  @override
  Future<void> addToMyChat(
      MyChatEntity myChatEntity, UserEntity allUsers) async {
    final myChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.senderUID)
        .collection('myChat');

    final otherChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection('myChat');

    final myNewChat = MyChatModel(
            time: myChatEntity.time,
            senderName: myChatEntity.senderName,
            senderUID: myChatEntity.senderPhoneNumber,
            recipientUID: myChatEntity.recipientUID,
            recipientName: myChatEntity.recipientName,
            channelId: myChatEntity.channelId,
            isArchived: myChatEntity.isArchived,
            isRead: myChatEntity.isRead,
            profileURL: myChatEntity.profileURL,
            recentTextMessage: myChatEntity.recentTextMessage,
            recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
            senderPhoneNumber: myChatEntity.senderPhoneNumber,
            name: myChatEntity.name)
        .toDocument();

    final otherNewChat = MyChatModel(
            time: myChatEntity.time,
            senderName: myChatEntity.recipientName,
            senderUID: myChatEntity.recipientUID,
            recipientUID: myChatEntity.senderUID,
            recipientName: myChatEntity.senderName,
            channelId: myChatEntity.channelId,
            isArchived: myChatEntity.isArchived,
            isRead: myChatEntity.isRead,
            profileURL: myChatEntity.profileURL,
            recentTextMessage: myChatEntity.recentTextMessage,
            recipientPhoneNumber: myChatEntity.senderPhoneNumber,
            senderPhoneNumber: myChatEntity.recipientPhoneNumber,
            name: myChatEntity.name)
        .toDocument();

    myChatRef.doc(myChatEntity.channelId).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        debugPrint('teste1223');
        //Create
        myChatRef.doc(myChatEntity.channelId).set(myNewChat);
        otherChatRef.doc(myChatEntity.channelId).set(otherNewChat);
        return;
      } else {
        debugPrint('teste321');
        //Update
        myChatRef.doc(myChatEntity.channelId).update(myNewChat);
        otherChatRef.doc(myChatEntity.channelId).update(otherNewChat);

        return;
      }
    });
  }

  @override
  Future<void> createOneToOneChatChannel(
      String uid, String name, List<UserEntity> allUsers) async {
    //Adiciona o canal em todas as conversas
    final userCollectionRef = fireStore.collection("users");
    final oneToOneChatChannelRef = fireStore.collection('myChatChannel');

    final Map<String, String> channelMap = {
      "channelId": name,
      "channelType": "oneToOneChat",
      "name": name,
      "uid": '111'
    };
    oneToOneChatChannelRef.doc(name).set(channelMap);

    final MyChatEntity myChatEntity = MyChatEntity(
      time: Timestamp.now(),
      senderUID: '111',
      recentTextMessage: "",
      profileURL: "",
      isRead: false,
      isArchived: false,
      channelId: name,
      name: '',
      recipientName: '',
      recipientPhoneNumber: '',
      recipientUID: '111',
      senderName: '',
      senderPhoneNumber: '',
    );

    final myNewChat = MyChatModel(
            time: myChatEntity.time,
            senderName: myChatEntity.senderName,
            senderUID: myChatEntity.senderPhoneNumber,
            recipientUID: myChatEntity.recipientUID,
            recipientName: myChatEntity.recipientName,
            channelId: myChatEntity.channelId,
            isArchived: myChatEntity.isArchived,
            isRead: myChatEntity.isRead,
            profileURL: myChatEntity.profileURL,
            recentTextMessage: myChatEntity.recentTextMessage,
            recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
            senderPhoneNumber: myChatEntity.senderPhoneNumber,
            name: myChatEntity.name)
        .toDocument();

    userCollectionRef.doc('111').collection('myChat').doc(name).set(myNewChat);

    //currentUser
    userCollectionRef
        .doc('111')
        .collection("engagedChatChannel")
        .doc(name)
        .set(channelMap);

    /*allUsers.forEach((element) {
      userCollectionRef
          .doc('111')
          .collection('engagedChatChannel')
          .doc(name)
          .get()
          .then((chatChannelDoc) {
        if (chatChannelDoc.exists) {
          return;
        }
        //if not exists
        final _chatChannelId = oneToOneChatChannelRef.doc().id;
        var channelMap = {
          "channelId": name,
          "channelType": "oneToOneChat",
          "name": name
        };
        oneToOneChatChannelRef.doc(name).set(channelMap);

        //currentUser
        userCollectionRef
            .doc('111')
            .collection("engagedChatChannel")
            .doc(name)
            .set(channelMap);

        //OtherUser

        userCollectionRef
            .doc(element.uid)
            .collection("engagedChatChannel")
            .doc(name)
            .set(channelMap);
      });

      return;
    });*/
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollectionRef = fireStore.collection("users");
    return userCollectionRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((docQuerySnapshot) => UserModel.fromSnapshot(docQuerySnapshot))
          .toList();
    });
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final messagesRef = fireStore
        .collection("myChatChannel")
        .doc(channelId)
        .collection('messages');

    return messagesRef.orderBy('time').snapshots().map(
          (querySnap) => querySnap.docs
              .map((doc) => TextMessageModel.fromSnapShot(doc))
              .toList(),
        );
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChatRef =
        fireStore.collection('users').doc(uid).collection('myChat');

    return myChatRef.snapshots().map(
          (querySnap) => querySnap.docs
              .map((doc) => MyChatModel.fromSnapShot(doc))
              .toList(),
        );
  }

  @override
  Future<void> deleteMessages(String channelId, List<String> messages) async {
    final messagesRef = fireStore
        .collection("myChatChannel")
        .doc(channelId)
        .collection('messages');

    final WriteBatch messagesBatch = fireStore.batch();

    for (String message in messages) {
      messagesBatch.delete(messagesRef.doc(message));
    }

    return await messagesBatch.commit();
  }

  @override
  Future<void> editMessage(
      String channelId, String messageId, String messageText) async {
    final messageRef = fireStore
        .collection("myChatChannel")
        .doc(channelId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({"message": messageText});
  }

  @override
  Future<String?> getOneToOneSingleUserChannelId(String uid, String canalName) {
    final userCollectionRef = fireStore;
    return userCollectionRef
        .doc(uid)
        .collection('engagedChatChannel')
        .where('name', isEqualTo: canalName)
        .get()
        .then((engagedChatChannel) {
      if (engagedChatChannel.docs.isNotEmpty) {
        return engagedChatChannel.docs.first.data()['channelId'];
      }
      return null;
    });
  }

  @override
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelId, UserEntity allUsers) async {
    final messageRef = fireStore.collection('myChatChannel').doc(channelId);

    final docRef = messageRef.collection('messages').doc();

    if (textMessageEntity.file != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref('$channelId/$fileName');
      await storageRef
          .putData(textMessageEntity.file!.bytes!)
          .then((snapshot) async {
        textMessageEntity.file?.id = snapshot.ref.name;
        textMessageEntity.file?.mime = snapshot.metadata?.contentType ?? 'none';
        textMessageEntity.file?.url = await snapshot.ref.getDownloadURL();
      });

      //.putData(textMessageEntity.file!.bytes);
    }

    final newMessage = TextMessageModel(
            message: textMessageEntity.message,
            messageId: docRef.id,
            messageType: textMessageEntity.messsageType,
            sederUID: textMessageEntity.sederUID,
            time: textMessageEntity.time,
            recipientName: textMessageEntity.senderName,
            recipientUID: textMessageEntity.sederUID,
            isResponse: textMessageEntity.isResponse,
            responseText: textMessageEntity.responseText,
            responseSenderName: textMessageEntity.responseSenderName,
            senderName: textMessageEntity.senderName,
            file: textMessageEntity.file)
        .toDocument();

    docRef.set(newMessage);
  }

  @override
  Future<void> uploadFileMessage(
      String canalName, String name, Uint8List file) async {
    final TaskSnapshot resultTask =
        await FirebaseStorage.instance.ref('$canalName}/$name').putData(file);
    debugPrint(resultTask.toString());
  }

  @override
  Future<String> getDownloadFileMessage(String canalName, String name) async {
    return await FirebaseStorage.instance
        .ref()
        .child('$canalName}/$name')
        .getDownloadURL();
  }

  @override
  Stream<DoubleConfigEntity> getDoubleConfig() {
    final doubleConfigDoc = fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection('blaze')
        .doc('doubleConfig');

    return doubleConfigDoc.snapshots().map((snapshot) {
      return snapshot.exists
          ? DoubleConfigModel.fromSnapshot(snapshot)
          : DoubleConfigModel.createDefault();
    });
  }

  @override
  Future<void> saveDoubleConfig(DoubleConfigModel doubleConfig) async {
    final doubleConfigDoc = fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection('blaze')
        .doc('doubleConfig');

    doubleConfigDoc.set(doubleConfig.toDocument(), SetOptions(merge: true));
  }

  @override
  Future<List<StrategyEntity>> getStrategies() async {
    final strategiesCollection = fireStore.collection("blazeDoubleStrategies");
    return Future(() async {
      final strategies = await strategiesCollection
          .where('enabled', isEqualTo: true)
          .where('env', isEqualTo: 'Application')
          .get();
      return strategies.docs
          .map((docQuerySnapshot) =>
              StrategyModel.fromSnapshot(docQuerySnapshot))
          .toList();
    });
  }

  @override
  Stream<CrashEntity?> getCrashEntity() {
    final colletion =
        fireStore.collection("configurations").doc('blazeCrashEntry');

    return colletion.snapshots().map((snapshot) {
      return snapshot.exists ? CrashModel.fromSnapshot(snapshot) : null;
    });
  }
}
