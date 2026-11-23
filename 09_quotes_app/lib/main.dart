import 'package:flutter/material.dart';
import 'core/getx.dart';
import 'controllers/quotes_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuoteScreen(),
  ));
}


/// Quote Screen using Obx reactive builder and FloatingActionButton refresh (Section 17)
class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuotesController controller = Get.put(QuotesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes App (GetX + REST API)'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching inspiring quote...', style: TextStyle(color: Colors.grey)),
                ],
              );
            }

            if (controller.quotes.isEmpty) {
              return const Text('No quotes loaded.');
            }

            final currentQuote = controller.quotes[0];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.format_quote, size: 54, color: Colors.indigoAccent),
                    const SizedBox(height: 16),
                    Text(
                      currentQuote.quote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— ${currentQuote.author}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.fetchQuote,
        icon: const Icon(Icons.refresh),
        label: const Text('New Quote'),
      ),
    );
  }
}