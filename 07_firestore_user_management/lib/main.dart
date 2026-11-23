import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'services/firestore_user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: UserManagementScreen(),
    ),
  );
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final FirestoreUserService _service = FirestoreUserService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  String? _selectedId;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _clearInputs() {
    _nameController.clear();
    _cityController.clear();
    _salaryController.clear();
    setState(() => _selectedId = null);
  }

  void _handleSubmit() async {
    final name = _nameController.text.trim();
    final city = _cityController.text.trim();
    final salary = int.tryParse(_salaryController.text.trim()) ?? 0;

    if (name.isNotEmpty && city.isNotEmpty && salary > 0) {
      if (_selectedId != null) {
        await _service.updateUser(_selectedId!, name, city, salary);
      } else {
        await _service.addUser(name, city, salary);
      }
      _clearInputs();
    }
  }

  void _editUser(UserModel user) {
    setState(() {
      _selectedId = user.id;
      _nameController.text = user.name;
      _cityController.text = user.city;
      _salaryController.text = user.salary.toString();
    });
  }

  void _deleteUser(String docId) async {
    await _service.deleteUser(docId);
    if (_selectedId == docId) {
      _clearInputs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Salary'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text(_selectedId != null ? 'Update' : 'Add'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final user = UserModel.fromMap(doc.id, data);

                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text('${user.city} - \$${user.salary}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editUser(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteUser(user.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
