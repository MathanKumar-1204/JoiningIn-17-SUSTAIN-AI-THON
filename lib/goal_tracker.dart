import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class GoalTrackerPage extends StatefulWidget {
  @override
  _GoalTrackerPageState createState() => _GoalTrackerPageState();
}

class _GoalTrackerPageState extends State<GoalTrackerPage> {
  List<Map<String, dynamic>> goals = [];
  Map<String, dynamic> newGoal = {
    'goal': '',
    'category': 'mindfulness',
    'deadline': '',
    'progress': 0
  };

  DateTime selectedDate = DateTime.now();
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  final _formKey = GlobalKey<FormState>();

  void handleChange(String field, String value) {
    setState(() {
      newGoal[field] = value;
    });
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        goals.add({...newGoal});
        newGoal = {'goal': '', 'category': 'mindfulness', 'deadline': '', 'progress': 0};
      });
    }
  }

  void markProgress(int index) {
    setState(() {
      if (goals[index]['progress'] < 100) {
        goals[index]['progress'] += 20;
        if (goals[index]['progress'] >= 100) {
          goals[index]['progress'] = 100;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Congratulations! You've completed a goal.")));
        }
      }
    });
  }

  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void handlePrevMonth() {
    setState(() {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
      } else {
        currentMonth--;
      }
    });
  }

  void handleNextMonth() {
    setState(() {
      if (currentMonth == 12) {
        currentMonth = 1;
        currentYear++;
      } else {
        currentMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal Tracker')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Goal Form
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    Text('Create a New Goal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) => handleChange('goal', value),
                            decoration: InputDecoration(labelText: 'Goal'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a goal';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: newGoal['category'],
                            onChanged: (value) => handleChange('category', value!),
                            items: ['mindfulness', 'sleep', 'exercise', 'time management']
                                .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                                .toList(),
                          ),
                          TextFormField(
                            onChanged: (value) => handleChange('deadline', value),
                            decoration: InputDecoration(labelText: 'Target Date'),
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a deadline';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(onPressed: handleSubmit, child: Text('Set Goal'))
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Completed Goals List
              Text('Completed Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GoalList(goals: goals, markProgress: markProgress, deleteGoal: deleteGoal),

              SizedBox(height: 20),

              // Calendar Navigation
              MonthNavigation(currentMonth: currentMonth, currentYear: currentYear, handlePrevMonth: handlePrevMonth, handleNextMonth: handleNextMonth),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalList extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final Function markProgress;
  final Function deleteGoal;

  GoalList({required this.goals, required this.markProgress, required this.deleteGoal});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: goals.where((goal) => goal['progress'] == 100).toList().length,
      itemBuilder: (context, index) {
        var goal = goals.where((goal) => goal['progress'] == 100).toList()[index];
        return Card(
          child: ListTile(
            title: Text('${goal['goal']} (${goal['category']})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${goal['deadline']}'),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(value: goal['progress'] / 100),
                    ),
                    Text('${goal['progress']}%'),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.check), onPressed: () => markProgress(index)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => deleteGoal(index)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MonthNavigation extends StatelessWidget {
  final int currentMonth;
  final int currentYear;
  final Function handlePrevMonth;
  final Function handleNextMonth;

  MonthNavigation({required this.currentMonth, required this.currentYear, required this.handlePrevMonth, required this.handleNextMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.chevron_left), onPressed: () => handlePrevMonth()),
        Text(DateFormat('MMMM yyyy').format(DateTime(currentYear, currentMonth))),
        IconButton(icon: Icon(Icons.chevron_right), onPressed: () => handleNextMonth()),
      ],
    );
  }
}