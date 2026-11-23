import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FormValidationApp(),
  ));
}


/// Form Validator Class as taught in Udemy Section 13
class FormValidator {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}

/// Udemy Course - Sections 12 & 13: Creating Forms & Validation
class FormValidationApp extends StatefulWidget {
  const FormValidationApp({super.key});

  @override
  State<FormValidationApp> createState() => _FormValidationAppState();
}

class _FormValidationAppState extends State<FormValidationApp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  final Map<String, dynamic> _formData = {
    'username': '',
    'email': '',
    'password': '',
    'phone': '',
    'role': 'Developer',
    'acceptedTerms': false,
  };

  bool _autovalidate = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_formData['acceptedTerms'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Form Validated!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${_formData['username']}'),
              Text('Email: ${_formData['email']}'),
              Text('Phone: ${_formData['phone']}'),
              Text('Role: ${_formData['role']}'),
              const SizedBox(height: 12),
              const Text(
                'Data successfully validated and saved (Sections 12 & 13).',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _passwordController.clear();
    setState(() {
      _autovalidate = false;
      _formData['acceptedTerms'] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Input & Validation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'User Registration Form',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Complete validation with RegExp, Controllers & Error feedback',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Username Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username *',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: FormValidator.validateUsername,
                onSaved: (val) => _formData['username'] = val?.trim() ?? '',
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  hintText: 'name@example.com',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: FormValidator.validateEmail,
                onSaved: (val) => _formData['email'] = val?.trim() ?? '',
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number (10 digits) *',
                  hintText: '9876543210',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: FormValidator.validatePhone,
                onSaved: (val) => _formData['phone'] = val?.trim() ?? '',
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password (8+ chars, 1 uppercase, 1 number) *',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: FormValidator.validatePassword,
                onSaved: (val) => _formData['password'] = val ?? '',
              ),
              const SizedBox(height: 16),

              // Confirm Password Field (Cross-field validation)
              TextFormField(
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password *',
                  prefixIcon: const Icon(Icons.lock_clock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (val != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // DropdownButtonFormField (Section 12)
              DropdownButtonFormField<String>(
                initialValue: _formData['role'],
                decoration: const InputDecoration(
                  labelText: 'Developer Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Developer', 'Designer', 'Product Manager', 'QA Engineer']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _formData['role'] = val);
                  }
                },
              ),
              const SizedBox(height: 16),

              // CheckboxListTile (Section 12)
              CheckboxListTile(
                value: _formData['acceptedTerms'] as bool,
                onChanged: (val) {
                  setState(() => _formData['acceptedTerms'] = val ?? false);
                },
                title: const Text('I accept the Terms and Conditions'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      child: const Text('Reset Form'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Form'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}