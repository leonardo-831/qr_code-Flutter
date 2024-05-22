class Event {
  final int? id;
  final String title;
  final String createdAt;
  final String updatedAt;

  Event({this.id, required this.title, required this.createdAt, required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}