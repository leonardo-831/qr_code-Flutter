import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Créditos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[800],
        elevation: 10,
        shadowColor: Colors.redAccent,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disciplina:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '- Desenvolvimento de Software',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                'Professor:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '- Prof. Dr. Elvio Gilberto da Silva',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                'Equipe:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '- Leonardo Belíssimo Muto',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              Text(
                '- Lucas Braga',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              Text(
                '- João Boconcelo',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              Text(
                '- Davi Guido',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              Text(
                '- Eduardo Ticianelli',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30),
              Text(
                'Desenvolvimento:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Center(
                child: Image(
                  image: AssetImage('assets/images/ciencia_da_computacao.jpg'),
                  height: 100,
                  width: 300,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Apoio:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Center(
                child: Image(
                  image:
                      AssetImage('assets/images/coordenadoria_de_extensao.jpg'),
                  height: 100,
                  width: 300,
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
