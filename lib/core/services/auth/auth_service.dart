import 'dart:io';

import 'package:flutter_chat/core/models/chat_user.dart';
import 'package:flutter_chat/core/services/auth/auth_mock_service.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  );

  Future<void> signin(
    String email,
    String password,
  );

  Future<void> signout();

  factory AuthService() {
    return AuthMockService();
  }
}
