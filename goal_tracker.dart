import 'package:flutter/material.dart';

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
    'milestones': '',
    'progress': 0
  };

  DateTime selectedDate = DateTime.now();
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  void handleChange(String field, String value) {
    setState(() {
      newGoal[field] = value;
    });
  }

  void handleSubmit() {
    setState(() {
      goals.add({
        ...newGoal,
        'milestones': newGoal['milestones'].split('\n').where((m) => m.trim().isNotEmpty).toList()
      });
      newGoal = {'goal': '', 'category': 'mindfulness', 'deadline': '', 'milestones': '', 'progress': 0};
    });
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
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]
                ),
                child: Column(
                  children: [
                    Text('Create a New Goal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      onChanged: (value) => handleChange('goal', value),
                      decoration: InputDecoration(labelText: 'Goal'),
                    ),
                    DropdownButton<String>(
                      value: newGoal['category'],
                      onChanged: (value) => handleChange('category', value!),
                      items: ['mindfulness', 'sleep', 'exercise', 'time management']
                          .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                          .toList(),
                    ),
                    TextField(
                      onChanged: (value) => handleChange('deadline', value),
                      decoration: InputDecoration(labelText: 'Target Date'),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      onChanged: (value) => handleChange('milestones', value),
                      decoration: InputDecoration(labelText: 'Milestones (separate by new line)'),
                      maxLines: 4,
                    ),
                    ElevatedButton(onPressed: handleSubmit, child: Text('Set Goal'))
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Completed Goals List
              Text('Completed Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
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
                          Text('Milestones: ${goal['milestones'].join(', ')}'),
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
              ),

              SizedBox(height: 20),

              // Calendar Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.chevron_left), onPressed: handlePrevMonth),
                  Text('$currentMonth - $currentYear'),
                  IconButton(icon: Icon(Icons.chevron_right), onPressed: handleNextMonth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
