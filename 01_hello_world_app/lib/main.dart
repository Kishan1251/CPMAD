import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('This is the first app'),
        ),
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text(
              'Hello from first app',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
