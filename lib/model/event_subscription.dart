class EventSubscription {
  int? id;
  int eventId;
  String aluno;
  int presence;
  String token;
  String createdAt;
  String updatedAt;

  EventSubscription({
    this.id,
    required this.eventId,
    required this.aluno,
    this.presence = 0,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'aluno': aluno,
      'presence': presence,
      'token': token,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static EventSubscription fromMap(Map<String, dynamic> map) {
    return EventSubscription(
      id: map['id'],
      eventId: map['event_id'],
      aluno: map['aluno'],
      presence: map['presence'],
      token: map['token'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  @override
  String toString() {
    return 'EventSubscription{id: $id, eventId: $eventId, aluno: $aluno, presence: $presence, token: $token, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
