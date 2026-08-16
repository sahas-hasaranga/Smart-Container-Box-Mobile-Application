import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../main.dart'; // To access MyApp.themeNotifier
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDarkMode = MyApp.themeNotifier.value == ThemeMode.dark;
    
    final backgroundColor = isDarkMode ? const Color(0xFF121B22) : const Color(0xFFF0F2F5);
    final cardColor = isDarkMode ? const Color(0xFF1F2C34) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? const Color(0xFF8696A0) : Colors.grey[600];
    final iconColor = isDarkMode ? const Color(0xFF8696A0) : Colors.grey[600];
    final accentColor = const Color(0xFF00A884); // WhatsApp Green

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: textColor),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accentColor, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null
                              ? const Icon(Icons.person, size: 40, color: Colors.grey)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: cardColor, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'User Name',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'No Email',
                          style: TextStyle(fontSize: 14, color: subtitleColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Smart Container User | Available',
                      iconColor: iconColor!,
                      textColor: textColor,
                      subtitleColor: subtitleColor!,
                      onTap: () => _showAboutModal(context, backgroundColor, cardColor, textColor, subtitleColor, accentColor),
                    ),
                    _buildDivider(cardColor),
                    _buildListTile(
                      icon: Icons.account_circle_outlined,
                      title: 'Account Settings',
                      subtitle: 'Privacy, security, change number',
                      iconColor: iconColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      onTap: () => _showAccountModal(context, backgroundColor, cardColor, textColor, subtitleColor, iconColor),
                    ),
                    _buildDivider(cardColor),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.dark_mode_outlined, color: iconColor),
                      ),
                      title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                      trailing: Switch(
                        value: isDarkMode,
                        activeColor: accentColor,
                        onChanged: (val) {
                          setState(() {
                            MyApp.themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 13)),
      trailing: Icon(Icons.arrow_forward_ios, color: subtitleColor, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider(Color cardColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 20),
      child: Divider(color: Colors.grey.withOpacity(0.2), height: 1),
    );
  }

  void _showAboutModal(BuildContext context, Color bgColor, Color cardColor, Color textColor, Color subtitleColor, Color accentColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Icon(Icons.local_shipping, size: 60, color: accentColor),
            const SizedBox(height: 16),
            Text("Smart Container", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Text("Version 1.0.0", style: TextStyle(color: subtitleColor)),
            const SizedBox(height: 20),
            Text(
              "Revolutionizing logistics and container tracking with real-time IoT integration. Stay connected with your fleet anywhere, anytime.",
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, height: 1.5),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showAccountModal(BuildContext context, Color bgColor, Color cardColor, Color textColor, Color subtitleColor, Color iconColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Account Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.person_outline, color: iconColor),
              title: Text("Edit Profile", style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context); // close modal
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.security, color: iconColor),
              title: Text("Change Password", style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context); // close modal
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text("Delete my account", style: TextStyle(color: Colors.redAccent)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
