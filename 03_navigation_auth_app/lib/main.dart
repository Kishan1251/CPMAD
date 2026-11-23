import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NamedRoutesApp());
}


/// Udemy Course - Section 11: Using Named Routes in Flutter
/// Demonstrates:
/// - initialRoute definition
/// - Centralized route dictionary: routes `Map<String, WidgetBuilder>`
/// - Dynamic routing with onGenerateRoute & RouteSettings arguments
/// - pushNamed and pushReplacementNamed navigation patterns
class NamedRoutesApp extends StatelessWidget {
  const NamedRoutesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Named Routes Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const _NamedSplashScreen(),
        '/login': (context) => const _NamedLoginScreen(),
        '/register': (context) => const _NamedRegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final username = settings.arguments as String? ?? 'Guest User';
          return MaterialPageRoute(
            builder: (context) => _NamedDashboardScreen(username: username),
          );
        }
        return null;
      },
    );
  }
}

class _NamedSplashScreen extends StatefulWidget {
  const _NamedSplashScreen();

  @override
  State<_NamedSplashScreen> createState() => _NamedSplashScreenState();
}

class _NamedSplashScreenState extends State<_NamedSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Navigation using pushReplacementNamed as taught in Section 11
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route, size: 84, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Named Routes Flow',
              style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Udemy Section 11', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _NamedLoginScreen extends StatefulWidget {
  const _NamedLoginScreen();

  @override
  State<_NamedLoginScreen> createState() => _NamedLoginScreenState();
}

class _NamedLoginScreenState extends State<_NamedLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _login() {
    final user = _usernameController.text.trim();
    if (user.isNotEmpty) {
      // Pass argument using named route
      Navigator.pushReplacementNamed(context, '/dashboard', arguments: user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login (Named Route)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login to Dashboard'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('New User? Register with Named Route'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NamedRegisterScreen extends StatelessWidget {
  const _NamedRegisterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register (Named Route)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Registration Screen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('Notice automatic back button in the AppBar!'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NamedDashboardScreen extends StatelessWidget {
  final String username;

  const _NamedDashboardScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard (Named Route)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user, size: 72, color: Colors.teal),
              const SizedBox(height: 16),
              Text(
                'Welcome, $username!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Arguments successfully passed via onGenerateRoute!'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}