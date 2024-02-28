import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/chat_message.dart';
import 'package:flutter_chat/core/models/chat_user.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'dart:async';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    // Faz a mesma coisa que acima
    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((snapshot) {
    //     for (final doc in snapshot.docs) {
    //       // Convert the data stream in a list
    //       List<ChatMessage> list =
    //           snapshot.docs.map((doc) => doc.data()).toList();
    //       controller.add(list);
    //     }
    //   });
    // });
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(msg);

    final docSnapshot = await docRef.get();
    return docSnapshot.data()!;
  }

  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> docSnapshot,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: docSnapshot.id,
      text: docSnapshot['text'],
      createdAt: DateTime.parse(docSnapshot['createdAt']),
      userId: docSnapshot['userId'],
      userName: docSnapshot['userName'],
      userImageUrl: docSnapshot['userImageUrl'],
    );
  }

  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageUrl': msg.userImageUrl,
    };
  }
}
