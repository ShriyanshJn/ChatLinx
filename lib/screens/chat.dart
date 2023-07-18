import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    // request permission from user to receive push notifications
    await fcm.requestPermission();
    //  address of the device on which our app is running, which we need to target this specific device (Here, sending push notifications using Firebase cloud messaging)
    // final token = fcm.getToken();
    // Since, we are using only one chat as a whole for all users we don't need to target a specific device as shown above,
    // Instead we can send a push notification to all logged in users
    fcm.subscribeToTopic('chat'); // after subscribing to this topic the device will receive push notifications from this topic 'chat
  }

  @override
  void initState() {
    setUpPushNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'C H A T L I N X',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // firebase will delete the user token both from its memory and the user device and user will be sent to suth screen
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      ),
    );
  }
}
