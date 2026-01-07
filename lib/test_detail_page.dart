import 'package:flutter/material.dart';

class TestDetailPage extends StatefulWidget {
  final String title;

  TestDetailPage({required this.title});

  @override
  _TestDetailPageState createState() => _TestDetailPageState();
}

class _TestDetailPageState extends State<TestDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _selectedAnswer = '';
  final Map<String, List<Map<String, dynamic>>> _tests = {
    'Механика': [
      {
        'question': 'Что такое сила по Ньютону?',
        'options': ['a) Скорость', 'b) Масса × Ускорение', 'c) Энергия', 'd) Время'],
        'correct': 'b',
      },
      {
        'question': 'Какой закон описывает F = m * a?',
        'options': ['a) Первый закон Ньютона', 'b) Второй закон Ньютона', 'c) Третий закон Ньютона', 'd) Закон Архимеда'],
        'correct': 'b',
      },
    ],
    'Электричество': [
      {
        'question': 'Что такое закон Ома?',
        'options': ['a) I = U / R', 'b) F = m * a', 'c) E = m * c²', 'd) P = I * V'],
        'correct': 'a',
      },
    ],
    'Термодинамика': [
      {
        'question': 'Что выражает первый закон термодинамики?',
        'options': ['a) ΔU = Q - W', 'b) F = m * a', 'c) I = U / R', 'd) v = u + a * t'],
        'correct': 'a',
      },
    ],
  };
  final List<String> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _userAnswers.addAll(List.filled(_tests[widget.title]!.length, ''));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final test = _tests[widget.title]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF4A90E2),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              itemCount: test.length,
              itemBuilder: (context, index) {
                final question = test[index];
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Вопрос ${index + 1}: ${question['question']}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ...question['options']!.map((option) {
                          final optionKey = option[0];
                          return RadioListTile<String>(
                            title: Text(option),
                            value: optionKey,
                            groupValue: _userAnswers[index],
                            onChanged: (value) {
                              setState(() {
                                _userAnswers[index] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}