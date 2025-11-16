import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// Re-using the User model definition for consistency
class User {
  final String id;
  final String name;
  final String email;
  final String userType; // 'Consumer' or 'Shop Owner'
  final String imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.imageUrl,
  });
}

class ConsumerListScreen extends StatelessWidget {
  const ConsumerListScreen({super.key});

  // Dummy data for users, filtered to consumers
  final List<User> consumers = const [
    User(id: '1', name: 'John Doe', email: 'john.d@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
    User(id: '3', name: 'Jane Smith', email: 'jane.s@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704e'),
    User(id: '5', name: 'Alex Johnson', email: 'alex.j@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704f'),
     User(id: '8', name: 'Emily Carter', email: 'emily.c@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704h'),
    User(id: '9', name: 'David Chen', email: 'david.c@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e2902670i'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Consumers'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView.separated(
          itemCount: consumers.length,
          separatorBuilder: (context, index) => const Divider(indent: 80, height: 1),
          itemBuilder: (context, index) {
            final user = consumers[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user.email),
              trailing: Chip(
                label: const Text(
                  'Consumer',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
