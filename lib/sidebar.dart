import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'community.dart';
import 'question_page.dart';
import 'chatbot.dart';
import 'goal_tracker.dart';
// import 'camera.dart';

class Sidebar extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final String username;

  const Sidebar({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black54 : Colors.blue,
            ),
            child: Text(
              'Welcome, $username!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildListTile(
            context,
            title: 'Dashboard',
            icon: Icons.dashboard,
            targetPage: DashboardPage(username: username),
          ),
          _buildListTile(
            context,
            title: 'Community',
            icon: Icons.people,
            targetPage: CommunityPage(),
          ),
          _buildListTile(
            context,
            title: 'Analysis',
            icon: Icons.analytics,
            targetPage: QuestionPage(username: username),
          ),
          _buildListTile(
            context,
            title: 'Chatbot',
            icon: Icons.chat,
            targetPage: const ChatbotPage(),
          ),
          _buildListTile(
            context,
            title: 'GoalTracker',
            icon: Icons.flag,
            targetPage: GoalTrackerPage(),
          ),
          // _buildListTile(
          //   context,
          //   title: 'Camera',
          //   icon: Icons.flag,
          //   targetPage: EmotionDetectionPage(),
          // ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          const Divider(),
          _buildDarkModeToggle(),
        ],
      ),
    );
  }

  /// Helper method to build a ListTile for navigation
  ListTile _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget targetPage,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
    );
  }

  /// Helper widget to build the dark mode toggle
  Widget _buildDarkModeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dark Mode',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: toggleTheme,
            child: Container(
              width: 50,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isDarkMode
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
