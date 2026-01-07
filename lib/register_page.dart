import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  String _selectedRole = 'Ученик';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (kIsWeb) {
        // Веб‑версия: просто считаем, что регистрация прошла успешно
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Регистрация успешна!')),
        );
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {
            'username': _usernameController.text.isEmpty
                ? 'Гость'
                : _usernameController.text,
            'role': _selectedRole,
          },
        );
        return;
      }

      // Мобильная версия: сохраняем пользователя в локальную БД
      final db = DatabaseHelper.instance;
      await db.insertUser({
        'username': _usernameController.text,
        'email': _emailController.text,
        'role': _selectedRole,
        'password': _passwordController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Регистрация успешна!')),
      );
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {
          'username': _usernameController.text.isEmpty
              ? 'Гость'
              : _usernameController.text,
          'role': _selectedRole,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.science, size: 60, color: Color(0xFF4A90E2)),
                    SizedBox(height: 20),
                    Text(
                      'Регистрация',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                        Icons.person, 'Имя пользователя', _usernameController),
                    SizedBox(height: 15),
                    _buildTextField(
                      Icons.lock,
                      'Пароль',
                      _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 15),
                    _buildTextField(Icons.email, 'Email', _emailController),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF4A90E2)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Color(0xFF4A90E2)),
                          items: ['Ученик', 'Учитель'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: Colors.black87)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() => _selectedRole = newValue!);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Уже есть аккаунт? Войти',
                        style: TextStyle(color: Color(0xFF4A90E2)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A90E2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Зарегистрироваться',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      IconData icon,
      String hint,
      TextEditingController controller, {
        bool obscureText = false,
      }) {
    return Semantics(
      label: hint,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
