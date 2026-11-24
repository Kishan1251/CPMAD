import '../../core/getx.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';

class QuotesController extends GetxController {
  final QuoteService _service = QuoteService();

  final quotes = <Quote>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    if (!isLoading.value) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final quote = await _service.fetchQuotes();
      quotes.assignAll([quote]);
    } catch (_) {
      errorMessage.value = 'Could not load a quote. Please try again.';
      quotes.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
