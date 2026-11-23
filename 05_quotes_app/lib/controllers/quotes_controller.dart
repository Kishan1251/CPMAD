import '../../core/getx.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';

class QuotesController extends GetxController {
  final QuoteService _service = QuoteService();

  var quotes = <Quote>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final quote = await _service.fetchQuotes();
    quotes.assignAll([quote]);
  }
}
