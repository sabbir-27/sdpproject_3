import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../models/chat_contact.dart';
import '../../models/message.dart';
import '../../theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Dummy message data
  final List<Message> _messages = [
    Message(text: 'Hi there! I have a question about my recent order.', senderId: 'customer1', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    Message(text: 'Hello! I can help with that. What is your order number?', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 4))),
    Message(text: 'It is #12345. I was wondering about the shipping status.', senderId: 'customer1', timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
    Message(text: 'Let me check that for you right now.', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 2))),
    Message(text: 'It looks like your order has been shipped and is scheduled to arrive tomorrow!', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 1))),
    Message(text: 'That\'s great news! Thank you so much for your help.', senderId: 'customer1', timestamp: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    // Rebuild the widget when the text controller changes to update the send icon
    _controller.addListener(() => setState(() {}));
  }

    @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(text: _controller.text, senderId: 'owner', timestamp: DateTime.now()));
      _controller.clear();
    });

    // Scroll to the bottom after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
       if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments as ChatContact? ?? ChatContact(name: 'Unknown', lastMessage: '', timestamp: DateTime.now(), imageUrl: 'https://i.pravatar.cc/150');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(contact),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], index);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ChatContact contact) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(contact.imageUrl),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.name, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Active now', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: AppColors.primary),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: AppColors.primary)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.videocam, color: AppColors.primary)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, int index) {
    final bool isOwner = message.senderId == 'owner';
    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: isOwner ? const LinearGradient(colors: [Color(0xFF00B2FF), Color(0xFF006AFF)], begin: Alignment.topRight, end: Alignment.bottomLeft) : null,
          color: isOwner ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(color: isOwner ? Colors.white : AppColors.textDark),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.jm().format(message.timestamp),
              style: TextStyle(fontSize: 10, color: isOwner ? Colors.white70 : Colors.black54),
            )
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).moveX(begin: isOwner ? 20 : -20, curve: Curves.easeOut);
  }

  Widget _buildMessageComposer() {
    final hasText = _controller.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            if (!hasText)
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.photo_camera_outlined, color: AppColors.primary), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.image_outlined, color: AppColors.primary), onPressed: () {}),
                ],
              ).animate().fadeIn(duration: 200.ms),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
