import 'package:flutter/material.dart';

class TheoryDetailPage extends StatefulWidget {
  final String topic;
  final List<Map<String, String>> tasks;

  TheoryDetailPage({required this.topic, required this.tasks});

  @override
  _TheoryDetailPageState createState() => _TheoryDetailPageState();
}

class _TheoryDetailPageState extends State<TheoryDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<TextEditingController> _answerControllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _answerControllers = List.generate(widget.tasks.length, (_) => TextEditingController());
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _answerControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic, style: TextStyle(fontWeight: FontWeight.bold)),
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
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
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
                        Text(task['task']!, style: TextStyle(fontSize: 16, height: 1.5)),
                        SizedBox(height: 10),
                        TextField(
                          controller: _answerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Ваш ответ',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
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