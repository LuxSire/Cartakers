import 'package:flutter/foundation.dart';
import 'package:xm_frontend/data/models/message_model.dart';

class ChatService {
  /// Sends a message to the specified chatId.
  // Future<void> sendMessage(
  //     String chatId, String receiverId, String messageContent) async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;

  //   if (uid == null) {
  //     throw Exception('User is not authenticated');
  //   }

  //   final chatRef = _firestore.collection('chats').doc(chatId);
  //   final messageRef = chatRef.collection('messages').doc();

  //   final message = MessageModel(
  //     senderId: uid,
  //     receiverId: receiverId,
  //     content: messageContent,
  //     timestamp: DateTime.now(),
  //     isRead: false,
  //     isDelivered: false,
  //   );

  //   final chatData = {
  //     "members": [uid, receiverId], // Add both sender and receiver to members
  //     "lastMessage": messageContent,
  //     "lastMessageTime": message.timestamp,
  //   };

  //   print("Chat Data: $chatData");
  //   print("Message Data: ${message.toMap()}");

  //   try {
  //     await _firestore.runTransaction((transaction) async {
  //       final chatSnapshot = await transaction.get(chatRef);

  //       if (!chatSnapshot.exists) {
  //         // Create the chat document if it doesn't exist
  //         transaction.set(chatRef, chatData);
  //       } else {
  //         // Update the lastMessage and lastMessageTime if the chat exists
  //         transaction.update(chatRef, {
  //           "lastMessage": messageContent,
  //           "lastMessageTime": message.timestamp,
  //         });
  //       }

  //       // Add the message to the messages subcollection
  //       transaction.set(messageRef, message.toMap());
  //     });

  //     print("Message sent successfully.");
  //   } catch (e) {
  //     print("Error sending message: $e");
  //     throw Exception("Failed to send message");
  //   }
  // }

  Future<void> sendMessage(
    String chatId,
    String receiverId,
    String messageContent,
    String senderName,
  ) async {
    // final uid = FirebaseAuth.instance.currentUser?.uid;

    // if (uid == null) {
    //   throw Exception('User is not authenticated');
    // }

    // final chatRef = _firestore.collection('chats').doc(chatId);
    // final messageRef = chatRef.collection('messages').doc();

    // final message = MessageModel(
    //   senderId: uid,
    //   receiverId: receiverId,
    //   content: messageContent,
    //   timestamp: DateTime.now(),
    //   isRead: false, // Initially false
    //   isDelivered: false, // Initially false
    // );

    // final chatData = {
    //   "members": [uid, receiverId], // Add both sender and receiver to members
    //   "lastMessage": messageContent,
    //   "lastMessageTime": message.timestamp,
    // };

    // try {
    //   await _firestore.runTransaction((transaction) async {
    //     final chatSnapshot = await transaction.get(chatRef);

    //     if (!chatSnapshot.exists) {
    //       // Create the chat document if it doesn't exist
    //       transaction.set(chatRef, chatData);
    //     } else {
    //       // Update the lastMessage and lastMessageTime if the chat exists
    //       transaction.update(chatRef, {
    //         "lastMessage": messageContent,
    //         "lastMessageTime": message.timestamp,
    //       });
    //     }

    //     // Add the message to the messages subcollection
    //     transaction.set(messageRef, message.toMap());

    //     // Mark the message as delivered
    //     transaction.update(messageRef, {"isDelivered": true});
    //   });

    //   print("Message sent successfully.");

    //   // get senders image

    //   final responseSender = await UserService().getTenantById(int.parse(uid));

    //   final senderImage =
    //       responseSender['profile_pic'] ?? ImageConstant.imgNetworkDefaultUser;

    //   List<Map<String, dynamic>> tenantDevices =
    //       await UserService().getTenantDeviceTokens(int.parse(receiverId));

    //   for (var device in tenantDevices) {
    //     String deviceToken = device['device_token'];
    //     String profilePic = device['profile_pic'];
    //     String displayName = device['display_name'];
    //     String receiverLangCode = device['lang'] ?? 'de';

    //     //debugPrint(
    //     //   "Token: $deviceToken, Name: $displayName, Prfoile: $profilePic, Lang: $receiverLangCode, Sender: $senderName, Message: $messageContent, Chat: $chatId, Receiver: $receiverId, uid: $uid, SenderImage: $senderImage");

    //     await UserService().sendChatPushNotification(
    //         deviceToken,
    //         senderName,
    //         messageContent,
    //         chatId,
    //         profilePic,
    //         displayName,
    //         receiverId,
    //         uid,
    //         senderImage,
    //         receiverLangCode);

    //     debugPrint("Sender Name: $senderName");
    //   }

    //   // Send push notifications to all registered devices
    //   // for (String token in receiverTokens) {
    //   //   await UserService()
    //   //       .sendPushNotification(token, senderName, messageContent, chatId);
    //   // }
    // } catch (e) {
    //   print("Error sending message: $e");
    //   throw Exception("Failed to send message");
    // }
  }

  Future<void> markMessagesAsRead(String chatId, String senderId) async {
    // final uid =
    //     FirebaseAuth.instance.currentUser?.uid; // Current logged-in user

    // if (uid == null) {
    //   throw Exception('User is not authenticated');
    // }

    // final messagesRef = FirebaseFirestore.instance
    //     .collection('chats')
    //     .doc(chatId)
    //     .collection('messages');

    // try {
    //   // Query messages sent by the sender to the logged-in user that are not read
    //   final querySnapshot = await messagesRef
    //       .where('senderId',
    //           isEqualTo: senderId) // Messages sent by the other user
    //       .where('isRead', isEqualTo: false) // Only unread messages
    //       .get();

    //   // Update each message's `isRead` field
    //   for (var doc in querySnapshot.docs) {
    //     await doc.reference.update({'isRead': true});
    //   }

    //   print('All messages marked as read for user: $uid');
    // } catch (e) {
    //   print('Error marking messages as read: $e');
    // }
  }

  /// Retrieves messages for a given chatId as a stream.
  // Stream<List<MessageModel>> getMessages(String chatId) {
  //   try {
  //     return _firestore
  //         .collection('chats')
  //         .doc(chatId)
  //         .collection('messages')
  //         .orderBy('timestamp', descending: true)
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         final data = doc.data();
  //         return MessageModel.fromMap(data); // No need for an id
  //       }).toList();
  //     });
  //   } catch (e) {
  //     print('Error fetching messages: $e');
  //     rethrow;
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getChatsBySenderId() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;

  //   if (uid == null) {
  //     throw Exception('User is not authenticated');
  //   }

  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('chats')
  //         .where('members', arrayContains: uid) // Filter by members
  //         .get();

  //     List<Map<String, dynamic>> chats = [];

  //     for (var chatDoc in querySnapshot.docs) {
  //       // Query the messages subcollection to check if senderId matches
  //       final messagesSnapshot = await chatDoc.reference
  //           .collection('messages')
  //           .where('senderId', isEqualTo: uid)
  //           .get();

  //       // If there are any messages from this user, add the chat to the list
  //       if (messagesSnapshot.docs.isNotEmpty) {
  //         chats.add({
  //           'chatId': chatDoc.id,
  //           ...chatDoc.data(),
  //         });
  //       }
  //     }

  //     return chats;
  //   } catch (e) {
  //     print("Error fetching chats: $e");
  //     throw Exception("Failed to fetch chats");
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getChatsForUser() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;

  //   if (uid == null) {
  //     throw Exception('User is not authenticated');
  //   }

  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('chats')
  //         .where('members', arrayContains: uid) // ✅ Fetch chats without sorting
  //         .get();

  //     return querySnapshot.docs
  //         .map((doc) => {
  //               'chatId': doc.id,
  //               ...doc.data(),
  //             })
  //         .toList();
  //   } catch (e) {
  //     print("Error fetching chats: $e");
  //     throw Exception("Failed to fetch chats");
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getChatsBySenderId() async { // old code
  //   final uid = FirebaseAuth.instance.currentUser?.uid;

  //   print("getChatsBySenderId User ID: $uid");
  //   if (uid == null) {
  //     throw Exception('User is not authenticated');
  //   }

  //   try {
  //     // Fetch all chats where the current user is the sender
  //     final querySnapshot = await _firestore
  //         .collection('chats')
  //         .where('senderId', isEqualTo: uid)
  //         .get();

  //     // Return chat data as a list of maps
  //     return querySnapshot.docs.map((doc) {
  //       return {
  //         'chatId': doc.id,
  //         ...doc.data(),
  //       };
  //     }).toList();
  //   } catch (e) {
  //     print("Error fetching chats: $e");
  //     throw Exception("Failed to fetch chats");
  //   }
  // }

  // Future<int> getUnreadMessageCount(String chatId, String receiverId) async {
  //   try {
  //     final messagesSnapshot = await _firestore
  //         .collection('chats')
  //         .doc(chatId)
  //         .collection('messages')
  //         .where('isRead', isEqualTo: false) // Only unread messages
  //         .where('receiverId',
  //             isEqualTo: receiverId) // Messages for the current user
  //         .get();

  //     return messagesSnapshot
  //         .docs.length; // Return the count of unread messages
  //   } catch (e) {
  //     print('Error fetching unread message count: $e');
  //     return 0; // Default to 0 on error
  //   }
  // }
}
