import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

// A more robust data model for messages
class Message {
  final String text;
  final String senderId;
  final DateTime timestamp;

  Message({required this.text, required this.senderId, required this.timestamp});
}

class UniversalChatScreen extends StatefulWidget {
  const UniversalChatScreen({super.key});

  @override
  State<UniversalChatScreen> createState() => _UniversalChatScreenState();
}

class _UniversalChatScreenState extends State<UniversalChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [
    Message(text: 'Hi there! I have a question about my recent order.', senderId: 'customer1', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    Message(text: 'Hello! I can help with that. What is your order number?', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 4))),
    Message(text: 'It is #12345. I was wondering about the shipping status.', senderId: 'customer1', timestamp: DateTime.now().subtract(const Duration(minutes: 3, seconds: 30))),
    Message(text: 'I can see you placed it yesterday.', senderId: 'customer1', timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
    Message(text: 'Let me check on that for you!', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 2))),
    Message(text: 'It looks like your order has been shipped and is scheduled to arrive tomorrow!', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 1))),
    Message(text: 'That\'s great news! Thank you so much for your help.', senderId: 'customer1', timestamp: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const String chatPartnerName = "Sabbir's Electronics";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, chatPartnerName),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final bool isMe = _messages[index].senderId == 'owner';
                final bool isLastInGroup = index == _messages.length - 1 || _messages[index + 1].senderId != _messages[index].senderId;
                return _buildMessageBubble(_messages[index], isMe, isLastInGroup);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String chatPartnerName) {
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      title: Row(
        children: [
          const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), radius: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chatPartnerName, style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Active now', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: AppColors.primary),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe, bool isLastInGroup) {
    final bubble = Container(
      margin: EdgeInsets.only(top: isLastInGroup ? 8.0 : 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        gradient: isMe ? const LinearGradient(colors: [Color(0xFF00B2FF), Color(0xFF006AFF)], begin: Alignment.topRight, end: Alignment.bottomLeft) : null,
        color: !isMe ? const Color(0xFFF0F2F5) : null,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(message.text, style: TextStyle(color: isMe ? Colors.white : AppColors.textDark, fontSize: 15)),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: bubble,
    ).animate().fadeIn(duration: 400.ms).moveX(begin: isMe ? 40 : -40, curve: Curves.easeOutCubic);
  }

  Widget _buildMessageComposer() {
    final hasText = _controller.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]),
      child: SafeArea(
        child: Row(
          children: [
            if (!hasText)
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primary), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.mic, color: AppColors.primary), onPressed: () {}),
                ],
              ).animate().fadeIn(duration: 200.ms),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24.0)),
                child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Aa', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 10))),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(hasText ? Icons.send : Icons.thumb_up_alt_rounded, color: AppColors.primary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
