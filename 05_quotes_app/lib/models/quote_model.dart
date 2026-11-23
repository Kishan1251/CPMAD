class Quote {
  final String q;
  final String a;

  Quote({
    required this.q,
    required this.a,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      q: json['q'] ?? json['quote'] ?? 'When you have vision, it affects your attitude.',
      a: json['a'] ?? json['author'] ?? 'Zig Ziglar',
    );
  }

  Map<String, dynamic> toJson() => {
        'q': q,
        'a': a,
      };
}
