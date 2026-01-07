import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _selectedFormula = 'Q = c·m·ΔT';
  final Map<String, String> _formulas = {
    'Q = c·m·ΔT': 'Количество теплоты (найти Q)',
    'c = Q / (m·ΔT)': 'Удельная теплоёмкость (найти c)',
    'm = Q / (c·ΔT)': 'Масса (найти m)',
    'Q = q·m': 'Количество теплоты сгорания (найти Q)',
    'A = Q = c·m·ΔT': 'Работа/Энергия (найти A)',
  };

  final Map<String, Map<String, dynamic>> _calculators = {
    'Q = c·m·ΔT': {
      'inputs': ['c (Дж/кг·℃)', 'm (кг)', 't₁ (℃)', 't₂ (℃)'],
      'useDeltaT': false,
      'description': 'Для расчета количества теплоты:\nc - удельная теплоёмкость\nm - масса\nt₁ - начальная температура\nt₂ - конечная температура',
    },
    'c = Q / (m·ΔT)': {
      'inputs': ['Q (Дж)', 'm (кг)', 't₁ (℃)', 't₂ (℃)'],
      'useDeltaT': false,
      'description': 'Для расчета удельной теплоёмкости:\nQ - количество теплоты\nm - масса\nt₁ - начальная температура\nt₂ - конечная температура',
    },
    'm = Q / (c·ΔT)': {
      'inputs': ['Q (Дж)', 'c (Дж/кг·℃)', 't₁ (℃)', 't₂ (℃)'],
      'useDeltaT': false,
      'description': 'Для расчета массы:\nQ - количество теплоты\nc - удельная теплоёмкость\nt₁ - начальная температура\nt₂ - конечная температура',
    },
    'Q = q·m': {
      'inputs': ['q (Дж/кг)', 'm (кг)'],
      'useDeltaT': true,
      'description': 'Для расчета теплоты сгорания:\nq - удельная теплота сгорания\nm - масса топлива',
    },
    'A = Q = c·m·ΔT': {
      'inputs': ['c (Дж/кг·℃)', 'm (кг)', 't₁ (℃)', 't₂ (℃)'],
      'useDeltaT': false,
      'description': 'Для расчета работы/энергии:\nc - удельная теплоёмкость\nm - масса\nt₁ - начальная температура\nt₂ - конечная температура',
    },
  };

  final Map<String, TextEditingController> _controllers = {};
  String _result = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _calculators.forEach((formula, data) {
      for (String input in data['inputs']) {
        _controllers[input] = TextEditingController();
      }
    });
  }

  void _calculate() {
    try {
      List<String> inputs = _calculators[_selectedFormula]!['inputs'];
      List<double> values = [];

      for (String input in inputs) {
        final value = double.parse(_controllers[input]!.text);
        values.add(value);
      }

      double result = 0;

      switch (_selectedFormula) {
        case 'Q = c·m·ΔT':
          double deltaT = (values[3] - values[2]).abs();
          result = values[0] * values[1] * deltaT;
          setState(() {
            _result = 'ΔT = ${deltaT.toStringAsFixed(2)} ℃\nQ = ${result.toStringAsFixed(2)} Дж\n(${(result / 1000).toStringAsFixed(2)} кДж)';
          });
          break;

        case 'c = Q / (m·ΔT)':
          double deltaT = (values[3] - values[2]).abs();
          result = values[0] / (values[1] * deltaT);
          setState(() {
            _result = 'ΔT = ${deltaT.toStringAsFixed(2)} ℃\nc = ${result.toStringAsFixed(2)} Дж/(кг·℃)';
          });
          break;

        case 'm = Q / (c·ΔT)':
          double deltaT = (values[3] - values[2]).abs();
          result = values[0] / (values[1] * deltaT);
          setState(() {
            _result = 'ΔT = ${deltaT.toStringAsFixed(2)} ℃\nm = ${result.toStringAsFixed(2)} кг\n(${(result * 1000).toStringAsFixed(2)} г)';
          });
          break;

        case 'Q = q·m':
          result = values[0] * values[1];
          setState(() {
            _result = 'Q = ${result.toStringAsFixed(2)} Дж\n(${(result / 1000000).toStringAsFixed(2)} МДж)';
          });
          break;

        case 'A = Q = c·m·ΔT':
          double deltaT = (values[3] - values[2]).abs();
          result = values[0] * values[1] * deltaT;
          setState(() {
            _result = 'ΔT = ${deltaT.toStringAsFixed(2)} ℃\nA = ${result.toStringAsFixed(2)} Дж\n(${(result / 1000).toStringAsFixed(2)} кДж)';
          });
          break;
      }
    } catch (e) {
      setState(() {
        _result = 'Ошибка! Заполните все поля корректными числами';
      });
    }
  }

  void _clearAll() {
    _controllers.forEach((key, controller) {
      controller.clear();
    });
    setState(() {
      _result = '';
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentInputs = _calculators[_selectedFormula]!['inputs'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Физический калькулятор', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выберите формулу:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF4A90E2)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedFormula,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            items: _formulas.entries.map((e) {
                              return DropdownMenuItem<String>(
                                value: e.key,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      e.key,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      e.value,
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedFormula = newValue;
                                  _result = '';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFF4A90E2).withOpacity(0.3)),
                        ),
                        child: Text(
                          _calculators[_selectedFormula]!['description'],
                          style: TextStyle(fontSize: 12, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Введите значения:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      ...currentInputs.map((input) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextField(
                            controller: _controllers[input],
                            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                            decoration: InputDecoration(
                              labelText: input,
                              hintText: 'Введите значение',
                              prefixIcon: Icon(Icons.calculate, color: Color(0xFF4A90E2)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _calculate,
                              icon: Icon(Icons.calculate),
                              label: Text('Рассчитать'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4A90E2),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _clearAll,
                            icon: Icon(Icons.clear),
                            label: Text('Очистить'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_result.isNotEmpty) ...[
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2).withOpacity(0.1), Color(0xFF50E3C2).withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Результат:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _result,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
