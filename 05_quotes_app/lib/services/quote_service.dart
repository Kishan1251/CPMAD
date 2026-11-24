import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quote_model.dart';

class QuoteService {
  static const String apiUrl = 'https://zenquotes.io/api/random';

  static final List<Quote> _fallbackQuotes = [
    Quote(
      q: 'When you have vision, it affects your attitude. Your attitude is optimistic rather than pessimistic.',
      a: 'Zig Ziglar',
    ),
    Quote(
      q: 'First, solve the problem. Then, write the code.',
      a: 'John Johnson',
    ),
    Quote(q: 'Simplicity is the soul of efficiency.', a: 'Austin Freeman'),
  ];

  static int _fallbackIndex = 0;

  Future<Quote> fetchQuotes() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final first = data[0];
          if (first is Map) {
            return Quote.fromJson(Map<String, dynamic>.from(first));
          }
        }
      }
    } catch (_) {
      // Fallback if offline
    }

    final quote = _fallbackQuotes[_fallbackIndex % _fallbackQuotes.length];
    _fallbackIndex++;
    return quote;
  }
}
