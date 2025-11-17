import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../models/chat_contact.dart';
import '../../theme/app_colors.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatContact> _chatContacts = [
    ChatContact(
      name: 'Mimi',
      lastMessage: "That\'s great news! Thank you...",
      timestamp: DateTime.now(),
      imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
      isRead: false,
    ),
    ChatContact(
      name: 'Sarlok',
      lastMessage: 'Can you check on order #54321?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704e',
      isRead: true,
    ),
    ChatContact(
      name: 'Tanny',
      lastMessage: 'Yes, it is available in blue.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704f',
      isRead: false,
    ),
     ChatContact(
      name: 'ASif',
      lastMessage: 'I\'ll be back.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704a',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          _buildSearchBar(),
          _buildActiveNowSection(),
          const SizedBox(height: 8),
          ..._chatContacts.map((contact) => _buildChatListItem(contact, _chatContacts.indexOf(contact))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_comment_outlined, color: Colors.white),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Chats', style: TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildChatListItem(ChatContact contact, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(contact.imageUrl),
      ),
      title: Text(contact.name, style: TextStyle(fontWeight: contact.isRead ? FontWeight.normal : FontWeight.bold)),
      subtitle: Text(
        contact.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: contact.isRead ? Colors.grey : AppColors.textDark, fontWeight: contact.isRead ? FontWeight.normal : FontWeight.bold),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat.jm().format(contact.timestamp), style: TextStyle(color: contact.isRead ? Colors.grey : AppColors.primary, fontSize: 12)),
          if (!contact.isRead) ...[const SizedBox(height: 4), const CircleAvatar(radius: 5, backgroundColor: AppColors.primary)],
        ],
      ),
      onTap: () => Navigator.pushNamed(context, '/owner_chat', arguments: contact),
    ).animate().fadeIn(delay: (100 * index).ms, duration: 300.ms);
  }

  Widget _buildActiveNowSection() {
    final activeContacts = _chatContacts.take(3).toList();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: activeContacts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildAddToStoryButton();
          final contact = activeContacts[index - 1];
          return _buildActiveContact(contact, index);
        },
      ),
    );
  }

  Widget _buildActiveContact(ChatContact contact, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(contact.imageUrl)),
              Positioned(
                bottom: -2, right: -2,
                child: Container(
                  width: 18, height: 18,
                  decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(contact.name.split(' ').first, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    ).animate().fadeIn(delay: (150 * index).ms);
  }

  Widget _buildAddToStoryButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.add, color: Colors.black, size: 24),
          ),
          const SizedBox(height: 8),
          const Text('Your Story', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
