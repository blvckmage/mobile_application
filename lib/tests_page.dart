import 'package:flutter/material.dart';
import 'test_detail_page.dart';

class TestsPage extends StatelessWidget {
  final List<Map<String, String>> _topics = [
    {'title': 'Механика', 'description': 'Тест по законам движения и силам.'},
    {'title': 'Электричество', 'description': 'Тест по электрическим цепям и законам.'},
    {'title': 'Термодинамика', 'description': 'Тест по теплу и энергии.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тесты', style: TextStyle(fontWeight: FontWeight.bold)),
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
          child: ListView.builder(
            itemCount: _topics.length,
            itemBuilder: (context, index) {
              final topic = _topics[index];
              return Card(
                elevation: 6,
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  leading: Icon(Icons.quiz, color: Color(0xFF4A90E2)),
                  title: Text(topic['title']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(topic['description']!, style: TextStyle(fontSize: 14)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestDetailPage(title: topic['title']!),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}