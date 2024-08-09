// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:worker_application/common/constants/app_id.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'package:worker_application/features/chat/model/chat_model.dart';
import 'package:worker_application/features/utility/dateformat.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _messagesStream;
  String? _chatRoomId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(backgroundColor: AppColors.textPrimaryColor,
        title: Text('ALFA Aluminium works',style: AppTextStyles.whiteBody(context),)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_auth.currentUser == null) {
      return Center(child: Text('Please log in to access the chat.'));
    }
    
    if (_chatRoomId == null) {
      return Center(child: Text('Unable to initialize chat. Please try again later.'));
    }
    
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _messagesStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No messages yet.'));
              }

              List<Message> messages = snapshot.data!.docs
                  .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                  .toList();

              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Message message = messages[index];
                  bool isMe = message.senderId == _auth.currentUser!.uid;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Color.fromARGB(255, 198, 220, 239) : Color.fromARGB(255, 235, 219, 235),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(message.content),
                          SizedBox(height: 5),
                          Text(
                            formatMessageTime(message.timestamp.toDate()),
                            style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 49, 48, 49)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.textPrimaryColor,
             shape: BoxShape.circle            ),
            child: IconButton(
              icon: Icon(Icons.send,color: AppColors.textsecondaryColor,),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _initializeChatRoom() async {
    if (_auth.currentUser != null) {
      try {
        QuerySnapshot chatRoomQuery = await _firestore
            .collection('chatRooms')
            .where('participants', arrayContains: _auth.currentUser!.uid)
            .get();

        QueryDocumentSnapshot? chatRoomDoc;
        for (var doc in chatRoomQuery.docs) {
          List<dynamic> participants = (doc.data() as Map<String, dynamic>)['participants'];
          if (participants.contains(AppConstants.COMPANY_ID)) {
            chatRoomDoc = doc;
            break;
          }
        }

        if (chatRoomDoc != null) {
          _chatRoomId = chatRoomDoc.id;
        } else {
          DocumentReference chatRoomRef = await _firestore.collection('chatRooms').add({
            'participants': [_auth.currentUser!.uid, AppConstants.COMPANY_ID],
            'lastMessageTimestamp': FieldValue.serverTimestamp(),
          });
          _chatRoomId = chatRoomRef.id;
        }

        _initializeMessagesStream();
      } catch (e) {
        print('Error initializing chat room: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _initializeMessagesStream() {
    if (_chatRoomId != null) {
      _messagesStream = _firestore
          .collection('chatRooms')
          .doc(_chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty && _auth.currentUser != null && _chatRoomId != null) {
      try {
        await _firestore.collection('chatRooms').doc(_chatRoomId).collection('messages').add({
          'senderId': _auth.currentUser!.uid,
          'content': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await _firestore.collection('chatRooms').doc(_chatRoomId).update({
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        });
        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message. Please try again.')),
        );
      }
    }
  }
}