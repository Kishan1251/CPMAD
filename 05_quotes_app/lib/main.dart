import 'package:flutter/material.dart';
import 'core/getx.dart';
import 'controllers/quotes_controller.dart';

void main() {
  runApp(
    const MaterialApp(
      home: QuoteScreen(),
    ),
  );
}

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuotesController controller = Get.put(QuotesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.quotes.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.quotes[0].q,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.quotes[0].a,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchDetails,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
