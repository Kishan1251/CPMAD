import 'package:flutter/material.dart';

import 'core/getx.dart';
import 'controllers/quotes_controller.dart';

void main() {
  runApp(
    const GetMaterialApp(
      title: 'Quotes App',
      debugShowCheckedModeBanner: false,
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
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Quotes App'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: controller.fetchDetails,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                );
              }

              if (controller.quotes.isEmpty) {
                return const Text('No quote available');
              }

              final quote = controller.quotes[0];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.format_quote,
                        size: 38,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        quote.q,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '— ${quote.a}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchDetails,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
