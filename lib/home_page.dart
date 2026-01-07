import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'tasks_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'Қонақ';
  String _email = 'example@mail.com';
  String _role = 'Оқушы';
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Қонақ';
      _email = prefs.getString('email') ?? 'example@mail.com';
      _role = prefs.getString('role') ?? 'Оқушы';
    });

    if (_role == 'Мұғалім') {
      await _loadStudents();
    }
  }

  Future<void> _loadStudents() async {
    final db = DatabaseHelper.instance;
    final students = await db.getStudents();
    setState(() {
      _students = students;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            if (_selectedIndex == 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(Icons.person, color: Color(0xFF4A90E2)),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Қош келдіңіз,',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            _username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else if (_selectedIndex == 1)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    'Тапсырмалар',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  _buildHomePage(),
                  Builder(builder: (context) => TasksPage()),
                  Builder(
                    builder: (context) => ProfilePage(
                      username: _username,
                      email: _email,
                      role: _role,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Color(0xFF4A90E2),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Басты бет'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Тапсырмалар'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Мұғалім үшін оқушылар тізімін көрсетеміз
          if (_role == 'Мұғалім') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Менің оқушыларым',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _loadStudents,
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 18, color: Color(0xFF4A90E2)),
                        SizedBox(width: 4),
                        Text(
                          'Жаңарту',
                          style: TextStyle(color: Color(0xFF4A90E2)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            if (_students.isEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Тіркелген оқушылар жоқ',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              )
            else
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: _students.map((student) {
                    return _buildStudentCard(
                      student['username'],
                      student['email'],
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 20),
          ],

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Физика бойынша іздеңіз...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF4A90E2)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Категориялар',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Барлығын көру',
                    style: TextStyle(color: Color(0xFF4A90E2)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryCard('Материалдар', Icons.book, onTap: () {
                  Navigator.pushNamed(context, '/materials');
                }),
                _buildCategoryCard('Тапсырмалар', Icons.quiz, onTap: () {
                  Navigator.pushNamed(context, '/theory');
                }),
                _buildCategoryCard('Калькулятор', Icons.calculate, onTap: () {
                  Navigator.pushNamed(context, '/calculator');
                }),
                _buildCategoryCard('Тесттер', Icons.assignment, onTap: () {
                  Navigator.pushNamed(context, '/tests');
                }),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStudentCard(String name, String email) {
    return Card(
      margin: EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF4A90E2),
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, {VoidCallback? onTap}) {
    return Card(
      margin: EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Color(0xFF4A90E2)),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
