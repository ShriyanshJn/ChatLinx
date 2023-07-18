import 'package:chat_app/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (context, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No messages found!',
              ),
            );
          }
          final loadedMessages = chatSnapshots.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 39,
              left: 13,
              right: 13,
              top: 1,
            ),
            reverse: true,
            itemBuilder: (context, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage = (index + 1 < loadedMessages.length)
                  ? loadedMessages[index + 1]
                  : null;
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  (nextChatMessage != null) ? nextChatMessage['userId'] : null;
              final nextUserIsSame = currentMessageUserId == nextMessageUserId;
              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: authenticatedUser!.uid == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser!.uid == currentMessageUserId,
                );
              }
            },
            itemCount: loadedMessages.length,
          );
        });
  }
}
