//api firebase
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ia_bet/data/datasource/api.dart';
import 'package:ia_bet/data/datasource/firebase_remote_datasource.dart';
import 'package:ia_bet/data/model/my_chat_model.dart';
import 'package:ia_bet/data/model/text_message_model.dart';
import 'package:ia_bet/data/model/user_model.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  String _verificationId = "";

  FirebaseRemoteDataSourceImpl({required this.auth, required this.fireStore});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUID();
    await userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
              status: user.status,
              profileUrl: user.profileUrl,
              isOnline: user.isOnline,
              uid: uid,
              phoneNumber: user.phoneNumber,
              email: user.email,
              name: user.name,
              isAdmin: user.isAdmin)
          .toDocument();
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
  Future<String> getCurrentUID() async => auth.currentUser!.uid;

  @override
  Stream<UserEntity> getCurrentUser() {
    print('tentando resgatar');
    final userCollection = fireStore.collection("users");
    final uid = auth.currentUser!.uid;
    return userCollection.doc(uid).snapshots().map((snapshot) {
      return UserModel.fromSnapshot(snapshot);
    });
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser!.uid != null;

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsPinCode);
    await auth.signInWithCredential(authCredential);
  }

  @override
  Future<void> signOut() async => await auth.signOut();

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    print(email);

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == 'user-not-found') {
        try {
          Map userLogin = {email: email, password: password};
          try {
            await auth.createUserWithEmailAndPassword(
                email: email, password: password);
          } on FirebaseAuthException catch (e) {
            return;
          }
        } catch (e) {
          return;
        }
      }
    }
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) {
      print("phone verified : Token ${authCredential.token}");
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException firebaseAuthException) {
      print(
        "phone failed : ${firebaseAuthException.message},${firebaseAuthException.code}",
      );
    };
    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      this._verificationId = verificationId;
      print("time out :$verificationId");
    };
    final PhoneCodeSent phoneCodeSent =
        (String verificationId, [int? forceResendingToken]) {} as PhoneCodeSent;
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
        print('teste1223');
        //Create
        myChatRef.doc(myChatEntity.channelId).set(myNewChat);
        otherChatRef.doc(myChatEntity.channelId).set(otherNewChat);
        return;
      } else {
        print('teste321');
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

    allUsers.forEach((element) {
      userCollectionRef
          .doc(element.uid)
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
    });
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

    return myChatRef.orderBy('time', descending: true).snapshots().map(
          (querySnap) => querySnap.docs
              .map((doc) => MyChatModel.fromSnapShot(doc))
              .toList(),
        );
  }

  @override
  Future<String> getOneToOneSingleUserChannelId(String uid, String canalName) {
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
      return Future.value(null);
    });
  }

  @override
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelId, UserEntity allUsers) async {
    final messageRef = fireStore.collection('myChatChannel').doc(channelId);

    //final messageId = messageRef.doc().id;

    final newMessage = TextMessageModel(
      message: textMessageEntity.message,
      messageId: '',
      messageType: textMessageEntity.messsageType,
      sederUID: textMessageEntity.sederUID,
      time: textMessageEntity.time,
      recipientName: allUsers.name,
      recipientUID: allUsers.uid,
      senderName: '',
    ).toDocument();

    messageRef.collection('messages').add(newMessage);
  }

  @override
  Future<void> uploadFileMessage(
      String canalName, String name, Uint8List file) async {
    TaskSnapshot resultTask =
        await FirebaseStorage.instance.ref('$canalName}/$name').putData(file);
  }

  @override
  Future<String> getDownloadFileMessage(String canalName, String name) async {
    return await FirebaseStorage.instance
        .ref()
        .child('$canalName}/$name')
        .getDownloadURL();
  }
}
