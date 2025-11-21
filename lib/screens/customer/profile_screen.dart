import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.username ?? 'Guest';
    final email = authProvider.email ?? 'guest@example.com';
    final role = authProvider.role ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : 'G',
                    style: const TextStyle(fontSize: 50, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: () {
                        // TODO: Implement Image Upload
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              username,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 4),
            Chip(
              label: Text(role.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            const SizedBox(height: 32),
            
            // Profile Info
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileTile(Icons.person_outline, 'Username', username),
                  const Divider(height: 1, indent: 60),
                  _buildProfileTile(Icons.email_outlined, 'Email', email),
                  const Divider(height: 1, indent: 60),
                  _buildProfileTile(Icons.verified_user_outlined, 'Role', role),
                  const Divider(height: 1, indent: 60),
                  _buildProfileTile(Icons.calendar_today_outlined, 'Joined', 'Oct 2023'), // Dummy Date
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Actions
            ElevatedButton.icon(
              onPressed: () => _showEditProfileDialog(context, username, email),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark)),
    );
  }

  void _showEditProfileDialog(BuildContext context, String currentName, String currentEmail) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call AuthProvider update method
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully! (Mock)')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
