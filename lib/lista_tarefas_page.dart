import 'package:flutter/material.dart';

class ListaTarefa extends StatelessWidget {
  const ListaTarefa({super.key});

  final List<Map<String, dynamic>> tarefas = [
    {
      'titulo': 'Configuração do ambiente', 'situacao':true,
      'titulo': 'Fazer compras', 'situacao':false,
      'titulo': 'Estudar Inglês', 'situacao':false,
      'titulo': 'Pagar a Fatura', 'situacao':true,
      'titulo': 'Fazer compras', 'situacao':true,

    }
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
        children: [
          
          //Concluidas

          Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Icon(
                Icons.check_circle, 
                color: Colors.green,
              ),
              title: Text(
                'Configurar o Ambiente de Desenvolvimento', 
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text('Concluida'),
              trailing: Icon(
                Icons.delete_outline,
                color: Colors.grey,
              ),
            ),
          ),


        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {},
        shape: CircleBorder(),  //deixa o botão redondo
        child: Icon(Icons.add),
      ),
    );
  }
}