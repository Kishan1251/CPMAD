import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'models/user_model.dart';
import 'services/firestore_user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const UserManagementScreen(),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  String? _selectedId;
  bool _isSaving = false;

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
    setState(() {
      _selectedId = null;
      _isSaving = false;
    });
  }

  void _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isSaving) {
      return;
    }

    final name = _nameController.text.trim();
    final city = _cityController.text.trim();
    final salary = int.parse(_salaryController.text.trim());
    final isUpdate = _selectedId != null;

    setState(() => _isSaving = true);
    try {
      if (isUpdate) {
        await _service.updateUser(_selectedId!, name, city, salary);
      } else {
        await _service.addUser(name, city, salary);
      }
      if (!mounted) return;
      _clearInputs();
      _showMessage(
        isUpdate ? 'User updated successfully.' : 'User added successfully.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('Could not save user. Please try again.', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  void _editUser(UserModel user) {
    setState(() {
      _selectedId = user.id;
      _nameController.text = user.name;
      _cityController.text = user.city;
      _salaryController.text = user.salary.toString();
    });
  }

  Future<void> _deleteUser(String docId) async {
    try {
      await _service.deleteUser(docId);
      if (!mounted) return;
      if (_selectedId == docId) {
        _clearInputs();
      }
      _showMessage('User deleted successfully.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not delete user. Please try again.', isError: true);
    }
  }

  Future<void> _confirmDelete(UserModel user) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete user'),
        content: Text('Delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _deleteUser(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Salary',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    validator: (value) {
                      final salary = int.tryParse(value?.trim() ?? '');
                      if (salary == null || salary <= 0) {
                        return 'Enter a salary greater than 0';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleSubmit(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isSaving ? null : _handleSubmit,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  _selectedId != null ? Icons.save : Icons.add,
                                ),
                          label: Text(
                            _selectedId != null ? 'Update User' : 'Add User',
                          ),
                        ),
                      ),
                      if (_selectedId != null) ...[
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _isSaving ? null : _clearInputs,
                          child: const Text('Cancel'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
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

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Could not load users. Check your connection and try again.',
                    ),
                  );
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
                            tooltip: 'Delete',
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDelete(user),
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
