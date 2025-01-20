import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'sidebar.dart';

class DashboardPage extends StatefulWidget {
  final String username;

  const DashboardPage({Key? key, required this.username}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _scores = [];
  bool _showAllScores = false;

  @override
  void initState() {
    super.initState();
    _fetchScores();
  }

  Future<void> _fetchScores() async {
    try {
      final snapshot = await _database.child('users/${widget.username}').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> scores = [];

        data.forEach((key, value) {
          if (value is Map && value.containsKey('score') && value.containsKey('state')) {
            scores.add({
              'date': key,
              'score': value['score'],
              'state': value['state'],
            });
          }
        });

        setState(() {
          _scores = scores;
        });
      } else {
        print('No data found for user: ${widget.username}');
      }
    } catch (e) {
      print('Error fetching scores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: Sidebar(
        isDarkMode: false,
        toggleTheme: () {
          // Implement theme toggle logic here
        },
        username: widget.username,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.username}!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Your Scores:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _showAllScores
                  ? ListView.builder(
                      itemCount: _scores.length,
                      itemBuilder: (context, index) {
                        final score = _scores[index];
                        return Card(
                          child: ListTile(
                            title: Text('Date: ${score['date']}'),
                            subtitle: Text('Score: ${score['score']}\nState: ${score['state']}'),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No scores displayed. Press "View All Scores" to see your scores.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_showAllScores)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showAllScores = true;
                      });
                    },
                    child: Text('View All Scores'),
                  ),
                if (_showAllScores)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showAllScores = false;
                      });
                    },
                    child: Text('Close Scores'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
