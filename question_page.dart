import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionPage extends StatefulWidget {
  final String username;

  QuestionPage({required this.username});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with WidgetsBindingObserver {
  final List<String> questions = [
    "How often do you find it difficult to relax?",
    "How often do you feel furious?",
    "Do you often feel unable to experience any positive feelings?",
    "Have you experienced difficulty in breathing without any clear reason?",
    "Do you struggle to find the motivation to start tasks?",
    "Do you tend to over-react to situations?",
    "How often do you feel like you're using a lot of nervous energy?",
    "Are you frequently worried about situations where you might panic?",
    "Do you feel downhearted and blue?",
    "Do you experience dizziness without any clear reason?",
    "Do you feel like you're close to panic?",
    "Are you aware of the action of your heart even when not exerting yourself?",
    "Do you feel that you are emotionally over-reacting?",
    "Do you feel like everything is moving too fast?",
    "Do you find it hard to concentrate?",
    "Do you feel that you don't want to socialize?",
    "Do you worry about situations that haven't happened yet?"
  ];

  final List<String> options = [
    'Never',
    'Rarely',
    'Sometimes',
    'Often',
    'Always'
  ];
  int currentQuestionIndex = 0;
  List<String?> answers = [];

  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    // Register this widget as an observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize the video controller
    _controller = VideoPlayerController.asset(
        'assets/ques.mp4') // Ensure this path is correct
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });

    // Initialize the answers list with a default value for each question
    answers = List<String?>.filled(questions.length, null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle lifecycle events
    if (_isVideoInitialized) {
      if (state == AppLifecycleState.paused) {
        _controller.pause();
      } else if (state == AppLifecycleState.resumed) {
        _controller.play();
      }
    }
  }

  void _handleAnswer(String answer) {
    setState(() {
      answers[currentQuestionIndex] = answer;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void _goToPreviousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  Future<void> _submitAnswers() async {
  final url = Uri.parse('https://807b-2409-40f4-a2-fcd3-4994-6fb3-e7b3-7b08.ngrok-free.app/submit');
  final answerList = answers.map((e) => e ?? '').toList();

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'answers': answerList, 'username': widget.username}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Submission successful!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to submit answers: $e')),
    );
  }
}


  @override
  void dispose() {
    // Remove the observer and dispose of the video controller
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Background
          if (_isVideoInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Foreground content (questions and answers)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Text
                Expanded(
                  child: Center(
                    child: Text(
                      questions[currentQuestionIndex],
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Options (Radio buttons)
                Column(
                  children: options.map((option) {
                    return RadioListTile<String>(
                      title:
                          Text(option, style: TextStyle(color: Colors.white)),
                      value: option,
                      groupValue: answers[currentQuestionIndex],
                      onChanged: (value) => _handleAnswer(value!),
                    );
                  }).toList(),
                ),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous Button
                    if (currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: _goToPreviousQuestion,
                        child: Text('Previous'),
                      ),
                    // Submit/Next Button
                    ElevatedButton(
                      onPressed: currentQuestionIndex == questions.length - 1
                          ? _submitAnswers
                          : () {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            },
                      child: Text(currentQuestionIndex == questions.length - 1
                          ? 'Submit'
                          : 'Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
