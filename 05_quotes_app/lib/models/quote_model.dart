/// Quote Model corresponding to QuickType conversion taught in Udemy Section 17
class Quote {
  final String quote;
  final String author;

  Quote({
    required this.quote,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['q'] ?? json['quote'] ?? 'The best way to get started is to quit talking and begin doing.',
      author: json['a'] ?? json['author'] ?? 'Walt Disney',
    );
  }

  Map<String, dynamic> toJson() => {
        'q': quote,
        'a': author,
      };
}
