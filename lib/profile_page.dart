import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String role;

  const ProfilePage({
    Key? key,
    required this.username,
    required this.email,
    required this.role,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  String aboutText = 'Например: Люблю физику и математику';

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => _imageFile = File(file.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки изображения: $e')),
      );
    }
  }

  Future<void> _editAboutText() async {
    final controller = TextEditingController(text: aboutText);
    final newText = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить описание'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Напишите о себе...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Сохранить'),
            onPressed: () => Navigator.pop(context, controller.text),
          ),
        ],
      ),
    );

    if (newText != null && newText.trim().isNotEmpty) {
      setState(() => aboutText = newText.trim());
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Очищаем все сохранённые данные
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Изменить фото',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoTile(
            icon: Icons.person_outline,
            title: 'Имя пользователя',
            subtitle: widget.username, // Используем widget.username
            onTap: () {},
          ),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: widget.email, // Используем widget.email
            onTap: () {},
          ),
          _buildInfoTile(
            icon: Icons.school_outlined,
            title: 'Статус',
            subtitle: widget.role, // Используем widget.role
            onTap: () {},
          ),
          _buildInfoTile(
            icon: Icons.edit,
            title: 'О себе',
            subtitle: aboutText,
            onTap: _editAboutText,
          ),
          const Divider(height: 40, thickness: 1, indent: 40, endIndent: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Выйти',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A90E2)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
