import 'package:flutter/material.dart';

class TheoryPage extends StatefulWidget {
  @override
  _TheoryPageState createState() => _TheoryPageState();
}

class _TheoryPageState extends State<TheoryPage> {
  final List<Map<String, String>> _problems = [
    {
      'title': 'Задача 1',
      'problem': 'Массасы 50 г, температурасы 25 ℃ алюминий қасықты температурасы 75 ℃ ыстық суға салса, қасық қанша жылу мөлшерін алады?',
      'correctAnswer': '2300',
      'unit': 'Дж',
    },
    {
      'title': 'Задача 2',
      'problem': 'Массасы 200 г затты 12 ℃-тан 16 ℃-қа қыздыру үшін 304 Дж жылу мөлшері жұмсалынды. Заттың меншікті жылусыйымдылығын анықтаңдар.',
      'correctAnswer': '380',
      'unit': 'Дж/(кг·℃)',
    },
    {
      'title': 'Задача 3',
      'problem': '168 кДж жылу мөлшерін жұмсап, қанша мөлшердегі суды 10 ℃-қа қыздыруға болады?',
      'correctAnswer': '4',
      'unit': 'кг',
    },
    {
      'title': 'Задача 4',
      'problem': 'Массасы 15 кг таскөмір толық жанғанда қанша жылу мөлшерін бөліп шығарады?',
      'correctAnswer': '450',
      'unit': 'МДж',
    },
    {
      'title': 'Задача 5',
      'problem': 'Бала массасы 20 г алюминий сымды әрі бері майыстырғанда, сымның температурасы 3 ℃-қа көтерілген. Баланың атқарған жұмысын анықтаңдар.',
      'correctAnswer': '55.2',
      'unit': 'Дж',
    },
  ];

  late List<TextEditingController> _answerControllers;
  late List<bool?> _answerStatus;

  @override
  void initState() {
    super.initState();
    _answerControllers = List.generate(
      _problems.length,
          (index) => TextEditingController(),
    );
    _answerStatus = List.generate(_problems.length, (index) => null);
  }

  void _checkAnswer(int index) {
    final userAnswer = _answerControllers[index].text.trim();
    final correctAnswer = _problems[index]['correctAnswer']!.trim();

    setState(() {
      try {
        double userValue = double.parse(userAnswer);
        double correctValue = double.parse(correctAnswer);

        if ((userValue - correctValue).abs() <= 0.1 || userValue == correctValue) {
          _answerStatus[index] = true;
        } else {
          _answerStatus[index] = false;
        }
      } catch (e) {
        _answerStatus[index] = false;
      }
    });
  }

  void _clearAnswer(int index) {
    setState(() {
      _answerControllers[index].clear();
      _answerStatus[index] = null;
    });
  }

  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задания', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            itemCount: _problems.length,
            itemBuilder: (context, index) {
              final problem = _problems[index];
              final isCorrect = _answerStatus[index];

              return Card(
                elevation: 6,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: isCorrect == null
                        ? null
                        : Border.all(
                      color: isCorrect ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              problem['title']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                            if (isCorrect != null)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isCorrect ? Icons.check_circle : Icons.cancel,
                                      color: isCorrect ? Colors.green : Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      isCorrect ? 'Правильно!' : 'Неправильно',
                                      style: TextStyle(
                                        color: isCorrect ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFF4A90E2).withOpacity(0.3)),
                          ),
                          child: Text(
                            problem['problem']!,
                            style: TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Введите ваш ответ:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _answerControllers[index],
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  hintText: 'Введите число',
                                  prefixIcon: Icon(Icons.edit, color: Color(0xFF4A90E2)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              problem['unit']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _checkAnswer(index),
                                icon: Icon(Icons.check),
                                label: Text('Проверить'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4A90E2),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () => _clearAnswer(index),
                              icon: Icon(Icons.clear),
                              label: Text('Очистить'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isCorrect == false)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info, color: Colors.red, size: 18),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Правильный ответ: ${problem['correctAnswer']!} ${problem['unit']!}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
