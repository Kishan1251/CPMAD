/// Udemy Course - Sections 15 & 16: Note Model
class Note {
  int? id;
  String title;
  String content;
  String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert Note object into a Map for SQLite storage
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract Note object from a SQLite Map object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      date: map['date'] as String? ?? '',
    );
  }
}
