class EventSubscription {
  final int? id;
  final int eventId;
  final String aluno;
  final String token;
  final bool presence;
  final String createdAt;
  final String updatedAt;

  EventSubscription({
    this.id,
    required this.eventId,
    required this.aluno,
    required this.token,
    this.presence = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'aluno': aluno,
      'token': token,
      'presence': presence ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static EventSubscription fromMap(Map<String, dynamic> map) {
    return EventSubscription(
      id: map['id'],
      eventId: map['event_id'],
      aluno: map['aluno'],
      token: map['token'],
      presence: map['presence'] == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}