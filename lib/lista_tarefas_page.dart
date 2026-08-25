import 'package:flutter/material.dart';

class ListaTarefa extends StatelessWidget {
  ListaTarefa({super.key});

  final List<Map<String, dynamic>> tarefas = [
    
      {'titulo': 'Configuração do ambiente', 'situacao': true},
      {'titulo': 'Fazer compras', 'situacao': false},
      {'titulo': 'Estudar Inglês', 'situacao': false},
      {'titulo': 'Pagar a Fatura', 'situacao': true},
      {'titulo': 'Fazer Compras', 'situacao': true},
      {'titulo': 'Sair as 22h00', 'situacao':false},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas tarefas"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {

          final tarefa = tarefas[index];
          final bool situacao = tarefa['situacao'];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Icon(
                situacao ? Icons.check_circle : Icons.circle_outlined, 
                color: situacao ? Colors.green : Colors.redAccent,
              ),
              title: Text(
                tarefa['titulo'], 
                style: TextStyle(
                  decoration: situacao ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              subtitle: situacao ? Text('Concluida') : Text('Pendente'),
              trailing: Icon(
                Icons.delete_outline,
                color: Colors.grey,
              ),
            ),
          );

        }


        
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {},
        shape: CircleBorder(),  //deixa o botão redondo
        child: Icon(Icons.add),
      ),
    );
  }
}