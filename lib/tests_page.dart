import 'package:flutter/material.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({Key? key}) : super(key: key);

  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  final List<Map<String, dynamic>> _testVariant1 = [
    {
      'question': 'Молекулалар мен атомдардың ретсіз қозғалысы ?',
      'options': ['Жылулық тепе-теңдік', 'Броундық қозғалыс', 'Конвекция', 'Жылулық қозғалыс'],
      'correctAnswer': 1,
    },
    {
      'question': 'Температура дегеніміз не?',
      'options': ['Дененің көлемін өлшейтін шама', 'Дененің қызу дәрежесін көрсететін шама', 'Дененің массасын көрсететін шама', 'Денедегі бөлшектер санын көрсететін шама'],
      'correctAnswer': 1,
    },
    {
      'question': 'Цельсий шкаласында судың қайнау температурасы қандай?',
      'options': ['0 °C', '50 °C', '100 °C', '273 °C'],
      'correctAnswer': 2,
    },
    {
      'question': 'Бөлшектердің бір заттан екінші затқа өздігінен өтуі қалай аталады?',
      'options': ['Конвекция', 'Диффузия', 'Сәуле шығару', 'Балқу'],
      'correctAnswer': 1,
    },
    {
      'question': 'Жылуөткізгіштік қай заттарда жақсы жүреді?',
      'options': ['Ауада', 'Сұйықта', 'Металлда', 'Пластилинде'],
      'correctAnswer': 2,
    },
    {
      'question': 'Конвекция қай орталарда жүреді?',
      'options': ['Қатты денелерде', 'Газдар мен сұйықтарда', 'Вакуумда', 'Металдарда'],
      'correctAnswer': 1,
    },
    {
      'question': 'Температураны өлшейтін құрал?',
      'options': ['Барометр', 'Амперметр', 'Термометр', 'Вольтметр'],
      'correctAnswer': 2,
    },
    {
      'question': 'Дененің ішкі энергиясын өзгерту тәсілдері?',
      'options': ['Тек қыздыру', 'Тек жұмыс істеу', 'Жылу беру және жұмыс істеу', 'Тек суыту'],
      'correctAnswer': 2,
    },
    {
      'question': 'Заттың барлық бөлшектерінің қозғалысы мен өзара әсерлесу энергиясы қалай аталады?',
      'options': ['Механикалық энергия', 'Ішкі энергия', 'Кинетикалық энергия', 'Потенциалдық энергия'],
      'correctAnswer': 1,
    },
    {
      'question': '30 ℃ температура мәнін Кельвинде жазыңдар ?',
      'options': ['273 К', '203 К', '243 К', '303 К'],
      'correctAnswer': 3,
    },
  ];

  final List<Map<String, dynamic>> _testVariant2 = [
    {
      'question': 'Жылу мөлшері қандай әріппен белгіленеді?',
      'options': ['F', 'Q', 'T', 'm'],
      'correctAnswer': 1,
    },
    {
      'question': 'Жылу берудің қай түрі вакуумда өтеді?',
      'options': ['Жылуөткізгіштік', 'Конвекция', 'Сәуле шығару', 'Ешқайсы'],
      'correctAnswer': 2,
    },
    {
      'question': 'Температураның өлшем бірлігі?',
      'options': ['Джоуль', 'Ньютон', 'Грамм', 'Градус'],
      'correctAnswer': 3,
    },
    {
      'question': 'Жылу өткізгіштігі нашар зат?',
      'options': ['Мыс', 'Ағаш', 'Алюминий', 'Темір'],
      'correctAnswer': 1,
    },
    {
      'question': 'Ішкі энергияның артуы нені білдіреді?',
      'options': ['Дененің қызуы төмендейді', 'Дененің бөлшектері баяулайды', 'Дененің қызуы артады', 'Дененің қатайуы'],
      'correctAnswer': 2,
    },
    {
      'question': 'Диффузияның ең жылдам жүретін ортасы?',
      'options': ['Қатты', 'Сұйық', 'Газ', 'Плазма'],
      'correctAnswer': 2,
    },
    {
      'question': '-273 °C температурасы қалай аталады?',
      'options': ['Абсолют нөл', 'Кристаллизация', 'Қату нүктесі', 'Бу түсу нүктесі'],
      'correctAnswer': 0,
    },
    {
      'question': 'Бу иісі үй ішінде жылдам таралуы ненің дәлелі?',
      'options': ['Конвекцияның', 'Диффузияның', 'Жылуөткізгіштіктің', 'Балқудың'],
      'correctAnswer': 1,
    },
    {
      'question': 'Жылу алмасудың түрі емес:',
      'options': ['Конвекция', 'Жылуөткізгіштік', 'Сәуле шығару', 'Булану'],
      'correctAnswer': 3,
    },
    {
      'question': '363 К температура мәнін Цельсий шкаласы бойынша градуста жазыңдар',
      'options': ['100 ℃', '90 ℃', '396 ℃', '103 ℃'],
      'correctAnswer': 1,
    },
  ];

  int? _selectedVariant;
  List<int?> _userAnswers = [];
  bool _testSubmitted = false;
  int _correctAnswers = 0;

  void _startTest(int variant) {
    setState(() {
      _selectedVariant = variant;
      _userAnswers = List.generate(
        variant == 1 ? _testVariant1.length : _testVariant2.length,
            (index) => null,
      );
      _testSubmitted = false;
      _correctAnswers = 0;
    });
  }

  void _submitTest() {
    if (_userAnswers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пожалуйста, ответьте на все вопросы'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final testData = _selectedVariant == 1 ? _testVariant1 : _testVariant2;
    int correct = 0;

    for (int i = 0; i < testData.length; i++) {
      if (_userAnswers[i] == testData[i]['correctAnswer']) {
        correct++;
      }
    }

    setState(() {
      _testSubmitted = true;
      _correctAnswers = correct;
    });
  }

  void _resetTest() {
    setState(() {
      _selectedVariant = null;
      _userAnswers = [];
      _testSubmitted = false;
      _correctAnswers = 0;
    });
  }

  double _getPercentage() {
    final testData = _selectedVariant == 1 ? _testVariant1 : _testVariant2;
    return (_correctAnswers / testData.length) * 100;
  }

  Color _getGradeColor() {
    final percentage = _getPercentage();
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getGrade() {
    final percentage = _getPercentage();
    if (percentage >= 90) return 'Отлично';
    if (percentage >= 80) return 'Хорошо';
    if (percentage >= 70) return 'Удовлетворительно';
    return 'Неудовлетворительно';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тесты', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: _selectedVariant == null
            ? _buildTestSelection()
            : (_testSubmitted ? _buildResults() : _buildTest()),
      ),
    );
  }

  Widget _buildTestSelection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Выберите вариант теста',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _startTest(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'Бақылау тесті 1-нұсқа',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startTest(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'Бақылау тесті 2-нұсқа',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTest() {
    final testData = _selectedVariant == 1 ? _testVariant1 : _testVariant2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.withOpacity(0.05)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Вариант теста ${_selectedVariant}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A90E2)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Всего вопросов: ${testData.length}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          ...List.generate(testData.length, (index) {
            final question = testData[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вопрос ${index + 1}',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      question['question'],
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ...List.generate(question['options'].length, (optionIndex) {
                      final isSelected = _userAnswers[index] == optionIndex;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _userAnswers[index] = optionIndex;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFF4A90E2).withOpacity(0.15) : Colors.grey[100],
                              border: Border.all(
                                color: isSelected ? Color(0xFF4A90E2) : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Color(0xFF4A90E2) : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF4A90E2),
                                      ),
                                    ),
                                  )
                                      : null,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question['options'][optionIndex],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Color(0xFF4A90E2) : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _submitTest,
            icon: Icon(Icons.send),
            label: Text('Сдать тест'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final testData = _selectedVariant == 1 ? _testVariant1 : _testVariant2;
    final percentage = _getPercentage();
    final grade = _getGrade();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [_getGradeColor().withOpacity(0.1), _getGradeColor().withOpacity(0.05)],
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 80, color: _getGradeColor()),
                  SizedBox(height: 16),
                  Text(
                    'Тест завершён',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getGradeColor(), width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ваш результат',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_correctAnswers / ${testData.length}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _getGradeColor(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getGradeColor(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          grade,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getGradeColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ваши ответы',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ...List.generate(testData.length, (index) {
                    final question = testData[index];
                    final userAnswer = _userAnswers[index];
                    final correctAnswer = question['correctAnswer'];
                    final isCorrect = userAnswer == correctAnswer;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCorrect ? Colors.green : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Вопрос ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ваш ответ: ${question['options'][userAnswer!]}',
                              style: TextStyle(fontSize: 12),
                            ),
                            if (!isCorrect)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Правильный: ${question['options'][correctAnswer]}',
                                  style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _resetTest,
                  icon: Icon(Icons.home),
                  label: Text('На главную'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _resetTest,
                  icon: Icon(Icons.refresh),
                  label: Text('Ещё тест'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
