import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: RandomColorPage(),
    ),
  );
}

class RandomColorPage extends StatefulWidget {
  const RandomColorPage({super.key});

  @override
  State<RandomColorPage> createState() => _RandomColorPageState();
}

class _RandomColorPageState extends State<RandomColorPage> {
  Color _containerColor = Colors.red;
  Color _fabColor = Colors.blue;
  Color _textColor = Colors.white;

  final Random _random = Random();

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  Color _getContrastColor(Color color) {
    // Luminance calculation: 0.299*R + 0.587*G + 0.114*B
    final r = (color.r * 255.0).round();
    final g = (color.g * 255.0).round();
    final b = (color.b * 255.0).round();
    final double luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    if (luminance > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  void _changeColor() {
    setState(() {
      _containerColor = _getRandomColor();
      _textColor = _getContrastColor(_containerColor);
      _fabColor = _getRandomColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Color Page'),
      ),
      body: Container(
        color: _containerColor,
        child: Center(
          child: Text(
            'Random Color',
            style: TextStyle(
              color: _textColor,
              fontSize: 24,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _fabColor,
        onPressed: _changeColor,
        child: Icon(
          Icons.refresh,
          color: _textColor,
        ),
      ),
    );
  }
}
