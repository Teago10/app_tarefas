import 'dart:ffi';

import 'package:app_tarefas/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class ListaTarefa extends StatefulWidget {
  ListaTarefa({super.key});

  @override
  State<ListaTarefa> createState() => _ListaTarefaState();
}

class _ListaTarefaState extends State<ListaTarefa> {
  List<Map<String, dynamic>> tarefas = [
    
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarTarefas();
  }

  void carregarTarefas() async{
    final dados = await DatabaseHelper.buscarTarefas();
    setState(() {
      tarefas = dados;
    });
  }

  //Marcar tarefa como concluida/Pendente

  void marcarSituacao(int index){
    setState(() {
      tarefas[index]['situacao'] = !tarefas[index]['situacao'];
    });
  }

  //Remover tarefa
  void removerTarefa(int index){
    setState(() {
      tarefas.removeAt(index);
    });
  }

  //Adicionar Tarefa
  void adicionarTarefa(){

    final adicinarController = TextEditingController();

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Nova Tarefa'),
        content: TextField(
          controller: adicinarController,
          decoration: InputDecoration(hintText: 'Digite sua Tarefa'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancelar')
            ),
          TextButton(
            onPressed: () async {
              if(adicinarController.text.isNotEmpty){
                
                await DatabaseHelper.inserirTarefa(adicinarController.text);

                carregarTarefas();

                if(!context.mounted) return;

                Navigator.pop(context);
              }
            }, 
            child: Text('Adicionar')
            ),
        ],
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas tarefas"),
        centerTitle: true,
      ),
      body: tarefas.isEmpty 
        ? Center(
          child: Text(
            'Nenhuma Tarefa Encontrada',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        )
        : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {

          final tarefa = tarefas[index];
          final bool situacao = tarefa['situacao'] == 1;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => marcarSituacao(index),
                child: Icon(
                  situacao ? Icons.check_circle : Icons.circle_outlined, 
                  color: situacao ? Colors.green : Colors.redAccent,
                ),
              ),
              title: Text(
                tarefa['titulo'], 
                style: TextStyle(
                  decoration: situacao ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              subtitle: situacao ? Text('Concluida') : Text('Pendente'),
              trailing: GestureDetector(
                onTap: () => removerTarefa(index),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.grey,
                ),
              ),
            ),
          );

        }


        
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: adicionarTarefa,
        shape: CircleBorder(),  //deixa o botão redondo
        child: Icon(Icons.add),
      ),
    );
  }
}