import '../../core/getx.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';

/// QuotesController using GetX reactive state (.obs) as taught in Udemy Section 17
class QuotesController extends GetxController {
  final QuoteService _service = QuoteService();

  var quotes = <Quote>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    isLoading.value = true;
    final quote = await _service.fetchRandomQuote();
    quotes.assignAll([quote]);
    isLoading.value = false;
  }
}
