import 'package:flutter/material.dart';

class MaterialsPage extends StatefulWidget {
  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  String _selectedTopic = 'Механика';
  final Map<String, String> _topics = {
    'Механика': 'Механика изучает движение тел и силы, действующие на них. Основные понятия: масса, ускорение, сила (F = m * a).',
    'Электричество': 'Электричество охватывает заряды, токи и поля. Закон Ома: I = U / R.',
    'Термодинамика': 'Термодинамика изучает тепло и энергию. Первый закон: ΔU = Q - W.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Материалы'),
        backgroundColor: Color(0xFF4A90E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedTopic,
              icon: Icon(Icons.arrow_drop_down, color: Color(0xFF4A90E2)),
              items: _topics.keys.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedTopic = newValue!);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _topics[_selectedTopic]!,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}