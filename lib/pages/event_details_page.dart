import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_service.dart';
import '../model/event_subscription.dart';
import '../model/event.dart';
import 'QrCode_scan.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _aluno = '';
  String _token = '';
  bool _presence = false;
  late Future<List<EventSubscription>> _eventSubscriptions;

  @override
  void initState() {
    super.initState();
    _loadEventSubscriptions();
  }

  void _loadEventSubscriptions() {
    setState(() {
      _eventSubscriptions =
          DatabaseService().getEventSubscriptions(widget.event.id!);
    });
  }

  Future<void> _saveEventSubscription() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String currentTime = DateTime.now().toIso8601String();
      EventSubscription newEventSubscription = EventSubscription(
        eventId: widget.event.id!,
        aluno: _aluno,
        token: _token,
        presence: _presence,
        createdAt: currentTime,
        updatedAt: currentTime,
      );

      await DatabaseService().insertEventSubscription(newEventSubscription);
      _loadEventSubscriptions();
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Aluno'),
                    onSaved: (value) {
                      _aluno = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o nome do aluno';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveEventSubscription,
                    child: Text('Salvar Inscrição'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Inscrições: ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<EventSubscription>>(
                future: _eventSubscriptions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Não tem inscrições'));
                  } else {
                    final subscriptions = snapshot.data!;
                    return ListView.builder(
                      itemCount: subscriptions.length,
                      itemBuilder: (context, index) {
                        final subscription = subscriptions[index];
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.black),
                              bottom: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: ListTile(
                            title: Text(subscription.aluno),
                            subtitle: Text(
                                'Presença: ${subscription.presence ? "Sim" : "Não"}'),
                            trailing: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 223, 108, 108),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.qr_code),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => QRCodeScan()),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
