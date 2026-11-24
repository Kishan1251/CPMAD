class Quote {
  final String q;
  final String a;

  const Quote({required this.q, required this.a});

  factory Quote.fromJson(Map<String, dynamic> json) {
    final quoteText = json['q'] ?? json['quote'];
    final author = json['a'] ?? json['author'];

    return Quote(
      q: quoteText is String && quoteText.trim().isNotEmpty
          ? quoteText.trim()
          : 'When you have vision, it affects your attitude.',
      a: author is String && author.trim().isNotEmpty
          ? author.trim()
          : 'Zig Ziglar',
    );
  }

  Map<String, dynamic> toJson() => {'q': q, 'a': a};
}
