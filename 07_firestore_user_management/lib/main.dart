import 'package:flutter/material.dart';
import 'core/firestore.dart';
import 'models/user_model.dart';
import 'services/firestore_user_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserManagementScreen(),
  ));
}


/// Udemy Course - Sections 19 & 20: Firebase Cloud Firestore User Management
/// Demonstrates:
/// - Real-time synchronization via StreamBuilder and Firestore snapshots
/// - Cloud Firestore CRUD operations: Create, Read, Update, Delete
/// - Dual mode form: Insert vs Update using selectedId
/// - Controller cleanup and input validation
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

  String? _selectedId; // Null for Add mode, contains doc ID for Edit mode

  bool get _isEditMode => _selectedId != null;

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

    if (name.isEmpty || city.isEmpty || salary <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid Name, City, and Salary.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isEditMode) {
      await _service.updateUser(_selectedId!, name, city, salary);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated in Cloud Firestore')),
        );
      }
    } else {
      await _service.addUser(name, city, salary);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added to Cloud Firestore')),
        );
      }
    }

    _clearInputs();
  }

  void _selectUserForEdit(UserModel user) {
    setState(() {
      _selectedId = user.id;
      _nameController.text = user.name;
      _cityController.text = user.city;
      _salaryController.text = user.salary.toString();
    });
  }

  void _deleteUser(String docId, String userName) async {
    await _service.deleteUser(docId);
    if (_selectedId == docId) {
      _clearInputs();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted $userName from Firestore')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Firestore User CRUD'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.cancel),
              tooltip: 'Cancel Edit',
              onPressed: _clearInputs,
            ),
        ],
      ),
      body: Column(
        children: [
          // Input Form Card (Section 20)
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isEditMode ? Icons.edit : Icons.person_add,
                        color: _isEditMode ? Colors.orange : Colors.indigo,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEditMode ? 'Update User Details' : 'Add New User to Firestore',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Salary (\$/yr)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEditMode ? Colors.orange : Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        icon: Icon(_isEditMode ? Icons.check : Icons.add),
                        label: Text(_isEditMode ? 'Update' : 'Add User'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Real-time Users List via StreamBuilder (Section 20)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('No users found in Cloud Firestore.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  itemCount: docs.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final user = UserModel.fromMap(doc.id, doc.data());
                    final isSelected = _selectedId == user.id;

                    return Card(
                      color: isSelected ? Colors.indigo.shade50 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? Colors.indigo : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected ? Colors.indigo : Colors.grey.shade200,
                          foregroundColor: isSelected ? Colors.white : Colors.black87,
                          child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?'),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'City: ${user.city}  •  Salary: \$${user.salary}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Edit User',
                              onPressed: () => _selectUserForEdit(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              tooltip: 'Delete User',
                              onPressed: () => _deleteUser(user.id, user.name),
                            ),
                          ],
                        ),
                        onTap: () => _selectUserForEdit(user),
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