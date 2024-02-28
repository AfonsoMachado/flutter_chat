import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/chat_message.dart';
import 'package:flutter_chat/core/models/chat_user.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'dart:async';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    return const Stream<List<ChatMessage>>.empty();
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    // ChatMessage => Map<String, dynamic>
    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.imageUrl,
    });

    final docSnapshot = await docRef.get();
    final data = docSnapshot.data()!;

    // Map<String, dynamic> => ChatMessage
    return ChatMessage(
      id: docSnapshot.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
      userId: data['userId'],
      userName: data['userName'],
      userImageUrl: data['userImageUrl'],
    );
  }
}
