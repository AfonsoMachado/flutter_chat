import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_user.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/notification/chat_notification_service.dart';
import 'package:flutter_chat/pages/auth_page.dart';
import 'package:flutter_chat/pages/chat_page.dart';
import 'package:flutter_chat/pages/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  // Inicialização da aplicação firebase
  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    
    // O listen fica false por estar fora da árvore de renderização
    await Provider.of<ChatNotificationService>(
      context,
      listen: false,
    ).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (BuildContext context, AsyncSnapshot<ChatUser?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const ChatPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
