import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (kIsWeb) {
        // Для веб - просто сохраняем в SharedPreferences с дефолтными данными
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('username', _usernameController.text.trim());
        await prefs.setString('email', _usernameController.text.trim() + '@example.com');
        await prefs.setString('role', 'Ученик');
        await prefs.setBool('isLoggedIn', true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Добро пожаловать, ${_usernameController.text.trim()}!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Для мобильной версии - используем БД
        final db = DatabaseHelper.instance;

        final user = await db.loginUser(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (user != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', user['username']);
          await prefs.setString('email', user['email']);
          await prefs.setString('role', user['role']);
          await prefs.setBool('isLoggedIn', true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Добро пожаловать, ${user['username']}!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _errorMessage = 'Неверное имя пользователя или пароль';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
      });
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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.science, size: 60, color: Color(0xFF4A90E2)),
                        SizedBox(height: 20),
                        Text(
                          'Вход',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (kIsWeb)
                          Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'На веб-версии: введите любое имя пользователя',
                                    style: TextStyle(fontSize: 12, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 20),

                        // Сообщение об ошибке
                        if (_errorMessage.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: Color(0xFF4A90E2)),
                            hintText: "Имя пользователя",
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Введите имя пользователя';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        if (!kIsWeb)
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Color(0xFF4A90E2)),
                              hintText: "Пароль",
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Введите пароль';
                              }
                              return null;
                            },
                          ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: Text(
                            'Нет аккаунта? Зарегистрироваться',
                            style: TextStyle(color: Color(0xFF4A90E2)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4A90E2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: _isLoading
                                ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text('Войти', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
