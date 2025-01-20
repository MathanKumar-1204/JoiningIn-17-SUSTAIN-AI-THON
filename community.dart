import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, dynamic>> users = [
    {'id': 1, 'username': 'Alice', 'tagline': 'Yoga Instructor', 'image': 'assets/alice.png'},
    {'id': 2, 'username': 'Bob', 'tagline': 'Meditator', 'image': 'assets/bob.png'},
    {'id': 3, 'username': 'Charlie', 'tagline': 'Psychologist', 'image': 'assets/charlie.png'},
  ];

  final List<Map<String, dynamic>> photos = [
    {'id': 1, 'image': 'assets/img1.png', 'description': 'Beautiful Sunset'},
    {'id': 2, 'image': 'assets/photo2.png', 'description': 'Mountain Hike'},
    {'id': 3, 'image': 'assets/photo3.png', 'description': 'City Lights'},
    {'id': 4, 'image': 'assets/photo4.png', 'description': 'Beach Day'},
  ];

  final Set<int> followedUsers = {};
  int? activeChat;
  List<Map<String, String>> messages = [];
  String newMessage = '';

  void followUser(int userId) {
    setState(() {
      if (followedUsers.contains(userId)) {
        followedUsers.remove(userId);
      } else {
        followedUsers.add(userId);
      }
    });
  }

  void startChat(int userId) {
    setState(() {
      activeChat = userId;
    });
  }

  void sendMessage() {
    if (newMessage.trim().isNotEmpty && activeChat != null) {
      setState(() {
        messages.add({
          'sender': 'You',
          'content': newMessage,
        });
        newMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: activeChat == null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'People You Might Know',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: users.map((user) {
                      return Card(
                        elevation: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(user['image'], width: 100, height: 100, fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(user['username'], style: const TextStyle(fontSize: 16)),
                            ),
                            Text(user['tagline'], style: const TextStyle(color: Colors.grey)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () => followUser(user['id']),
                                  child: Text(followedUsers.contains(user['id']) ? 'Following' : 'Follow'),
                                ),
                                if (followedUsers.contains(user['id']))
                                  IconButton(
                                    icon: const Icon(Icons.message),
                                    onPressed: () => startChat(user['id']),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Photo Gallery',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: photos.map((photo) {
                      return Card(
                        child: Column(
                          children: [
                            Image.asset(photo['image'], width: 150, height: 150, fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(photo['description']),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() {
                      activeChat = null;
                    }),
                  ),
                  title: Text(users.firstWhere((u) => u['id'] == activeChat)['username']),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]['sender']!),
                        subtitle: Text(messages[index]['content']!),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => newMessage = value,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
