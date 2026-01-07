import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database_helper.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _students = [];
  String _username = 'Гость';
  String _role = 'Ученик';
  String? _selectedStudent;
  File? _selectedFile;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'Гость';
    _role = prefs.getString('role') ?? 'Ученик';

    await _loadTasks();

    // Если учитель - загружаем список учеников
    if (_role == 'Учитель') {
      await _loadStudents();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadStudents() async {
    final db = DatabaseHelper.instance;
    final students = await db.getStudents();
    setState(() {
      _students = students;
    });
  }

  Future<void> _loadTasks() async {
    final db = DatabaseHelper.instance;
    List<Map<String, dynamic>> tasks;

    if (_role == 'Учитель') {
      tasks = await db.getTeacherTasks(_username);
    } else {
      tasks = await db.getStudentTasks(_username);
    }

    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_role != 'Учитель') return;

    showDialog(
      context: context,
      builder: (context) {
        String? dialogSelectedStudent = _selectedStudent;
        File? dialogSelectedFile = _selectedFile;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Добавить задание'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown для выбора ученика из БД
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Выберите ученика',
                        prefixIcon: Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      value: dialogSelectedStudent,
                      items: _students.map((student) {
                        return DropdownMenuItem<String>(
                          value: student['username'],
                          child: Text(student['username']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          dialogSelectedStudent = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Выберите ученика';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Описание задания',
                        prefixIcon: Icon(Icons.description_outlined, color: Color(0xFF4A90E2)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              dialogSelectedFile != null
                                  ? 'Файл: ${dialogSelectedFile!.path.split('/').last}'
                                  : 'Файл не выбран',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles();
                            if (result != null && result.files.isNotEmpty) {
                              setDialogState(() {
                                dialogSelectedFile = File(result.files.first.path!);
                              });
                            }
                          },
                          icon: Icon(Icons.attach_file, size: 18),
                          label: Text('Выбрать'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _descriptionController.clear();
                    _selectedFile = null;
                    _selectedStudent = null;
                    Navigator.pop(context);
                  },
                  child: Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (dialogSelectedStudent == null ||
                        dialogSelectedStudent!.isEmpty ||
                        _descriptionController.text.isEmpty ||
                        dialogSelectedFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Заполните все поля'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Сохраняем задание в БД
                    final db = DatabaseHelper.instance;
                    await db.addTask(
                      teacher: _username,
                      student: dialogSelectedStudent!,
                      description: _descriptionController.text,
                      fileName: dialogSelectedFile!.path.split('/').last,
                      filePath: dialogSelectedFile!.path,
                    );

                    _descriptionController.clear();
                    _selectedStudent = null;
                    _selectedFile = null;

                    // Перезагружаем задания
                    await _loadTasks();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Задание успешно добавлено!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTask(int id) async {
    final db = DatabaseHelper.instance;
    await db.deleteTask(id);
    await _loadTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Задание удалено'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _downloadFile(String path) async {
    try {
      if (await canLaunchUrl(Uri.file(path))) {
        await launchUrl(Uri.file(path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть файл')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                _role == 'Учитель' ? 'Мои выданные задания' : 'Мои задания',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _tasks.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.assignment_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        _role == 'Учитель'
                            ? 'Вы еще не выдали заданий'
                            : 'У вас нет заданий',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      if (_role == 'Учитель')
                        Text(
                          'Нажмите "+" чтобы добавить задание',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF4A90E2),
                        child: Icon(
                          _role == 'Учитель'
                              ? Icons.assignment_turned_in
                              : Icons.assignment,
                          color: Colors.white,
                        ),
                        radius: 24,
                      ),
                      title: Text(
                        task['description'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            _role == 'Учитель'
                                ? 'Для: ${task['student']}'
                                : 'От: ${task['teacher']}',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Файл: ${task['fileName']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.download, color: Color(0xFF4A90E2)),
                                SizedBox(width: 10),
                                Text('Скачать'),
                              ],
                            ),
                            onTap: () => _downloadFile(task['filePath']),
                          ),
                          if (_role == 'Учитель')
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Удалить'),
                                ],
                              ),
                              onTap: () => _deleteTask(task['id']),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _role == 'Учитель'
          ? FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Color(0xFF4A90E2),
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}
