import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

/// QuoteService fetching remote quotes via HTTP (Section 17)
class QuoteService {
  static const String apiUrl = 'https://dummyjson.com/quotes/random';

  static final List<Quote> _fallbackQuotes = [
    Quote(
      quote: 'When you have vision, it affects your attitude. Your attitude is optimistic rather than pessimistic.',
      author: 'Zig Ziglar',
    ),
    Quote(
      quote: 'First, solve the problem. Then, write the code.',
      author: 'John Johnson',
    ),
    Quote(
      quote: 'Simplicity is the soul of efficiency.',
      author: 'Austin Freeman',
    ),
    Quote(
      quote: 'Code is like humor. When you have to explain it, it’s bad.',
      author: 'Cory House',
    ),
  ];

  static int _fallbackIndex = 0;

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Quote.fromJson(data);
      }
    } catch (_) {
      // Offline fallback ensuring app runs anywhere
    }

    // Return rotating fallback quote if network is offline
    final quote = _fallbackQuotes[_fallbackIndex % _fallbackQuotes.length];
    _fallbackIndex++;
    return quote;
  }
}
