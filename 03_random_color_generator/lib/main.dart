import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RandomColorApp(),
  ));
}


/// Udemy Course - Section 8: Stateful Widget & Random Color Generator
/// Demonstrates:
/// - Converting StatelessWidget to StatefulWidget
/// - State class lifecycle and the role of setState()
/// - Dynamic RGB color generation using dart:math Random
/// - Mathematical contrast calculation for accessible text & FAB colors
class RandomColorApp extends StatefulWidget {
  const RandomColorApp({super.key});

  @override
  State<RandomColorApp> createState() => _RandomColorAppState();
}

class _RandomColorAppState extends State<RandomColorApp> {
  // Dynamic color variables as taught in Udemy Section 8
  Color _containerColor = Colors.blue;
  Color _fabColor = Colors.white;
  Color _textColor = Colors.white;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _changeColor();
  }

  /// Generates a random color within 0..255 RGB limits
  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  /// Calculates high-contrast color (black or white) based on relative luminance
  Color _getContrastColor(Color background) {
    // Relative luminance calculation from course lecture
    final r = (background.r * 255.0).round().clamp(0, 255);
    final g = (background.g * 255.0).round().clamp(0, 255);
    final b = (background.b * 255.0).round().clamp(0, 255);
    final double luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Updates UI state using setState
  void _changeColor() {
    setState(() {
      _containerColor = _getRandomColor();
      _textColor = _getContrastColor(_containerColor);
      _fabColor = _getContrastColor(_containerColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final redVal = (_containerColor.r * 255.0).round().clamp(0, 255);
    final greenVal = (_containerColor.g * 255.0).round().clamp(0, 255);
    final blueVal = (_containerColor.b * 255.0).round().clamp(0, 255);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Color Generator'),
        backgroundColor: _containerColor,
        foregroundColor: _textColor,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        color: _containerColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Color Hex:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _textColor.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _textColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _textColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '#${_containerColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: _textColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'RGB($redVal, $greenVal, $blueVal)',
                style: TextStyle(
                  fontSize: 16,
                  color: _textColor.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _changeColor,
                icon: const Icon(Icons.refresh),
                label: const Text('Generate Random Color'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _fabColor,
                  foregroundColor: _containerColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _changeColor,
        backgroundColor: _fabColor,
        foregroundColor: _containerColor,
        icon: const Icon(Icons.palette),
        label: const Text('Change Color'),
      ),
    );
  }
}