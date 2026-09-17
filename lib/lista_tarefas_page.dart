import 'dart:ffi';

import 'package:app_tarefas/database_helper.dart';
import 'package:app_tarefas/sobre_aplicativo_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class ListaTarefa extends StatefulWidget {
  ListaTarefa({super.key});

  @override
  State<ListaTarefa> createState() => _ListaTarefaState();
}

class _ListaTarefaState extends State<ListaTarefa> {
  List<Map<String, dynamic>> tarefas = [];

  String? filtroAtual;

  static const categorias = ['Pessoal', 'Trabalho', 'Estudo', 'Compras'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarTarefas();
  }

  void carregarTarefas() async {
    final dados = await DatabaseHelper.buscarTarefas(filtro: filtroAtual);
    setState(() {
      tarefas = dados;
    });
  }

  //Marcar tarefa como concluida/Pendente

  Future<void> marcarSituacao(int index) async {
    final tarefa = tarefas[index];
    final novaSituacao = tarefa['situacao'] == 1 ? 0 : 1;

    await DatabaseHelper.atualizarSituacao(
      tarefa['id'],
      novaSituacao,
    );

    carregarTarefas();
  }

  //Mudar filtro dos dados= Todas, Pendentes e Concluidas

  void aplicarFiltro(String? novoFiltro){
    filtroAtual = novoFiltro;
    Navigator.pop(context);
    carregarTarefas();
  }

  //Remover tarefa
  Future<void> removerTarefa(int index) async {
    final tarefa = tarefas[index];

    await DatabaseHelper.removerSituacao(
      tarefa['id'],
    );

    carregarTarefas();
  }

  //Adicionar Tarefa
  void adicionarTarefa() {
    final adicinarController = TextEditingController();
    String categoriaEscolhida = categorias.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDiaLog) {
            return AlertDialog(
              title: Text('Nova Tarefa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: adicinarController,
                    decoration: InputDecoration(hintText: 'Digite sua Tarefa'),
                  ),
                  SizedBox(height: 12,),

                  DropdownButton<String>(
                    value: categoriaEscolhida,
                    isExpanded: true,
                    items: categorias.map((cat) {
                      return DropdownMenuItem(
                        value: cat, 
                        child: Text(cat),
                        );
                    }).toList(),
                    
                    onChanged: (novaCategoria) {
                      setStateDiaLog(
                        () {
                          categoriaEscolhida = novaCategoria!;
                        },);
                    },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (adicinarController.text.isNotEmpty) {
                      await DatabaseHelper.inserirTarefa(
                        adicinarController.text,
                        categoriaEscolhida,
                        );
            
                      carregarTarefas();
            
                      if (!context.mounted) return;
            
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Adicionar'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas tarefas"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                "Minhas Tarefas",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Todas as Tarefas'),
              selected: filtroAtual == null,
              selectedColor: Colors.blue[700],
              onTap: () => aplicarFiltro(null),
            ),
            ListTile(
              leading: Icon(Icons.pending_actions),
              title: Text('Pendentes'),
              selected: filtroAtual == 'pendentes',
              selectedColor: Colors.blue[700],
              onTap: () => aplicarFiltro('pendentes'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Concluidos'),
              selected: filtroAtual == 'concluidos',
              selectedColor: Colors.blue[700],
              onTap: () => aplicarFiltro('concluidos'),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Sobre o Aplicativo'),
              onTap: () {

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SobrePage()
                  ),
                );

              },
            ),
          ],
        ),
      ),
      body: tarefas.isEmpty
          ? Center(
              child: Text(
                'Nenhuma Tarefa Encontrada. Toque em + para adicionar',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                final bool situacao = tarefa['situacao'] == 1;
                final String categoria = tarefa['categoria'] ?? 'Sem categoria';

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
                        decoration: situacao
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      '${situacao ? 'Concluida' : 'Pendente'} - $categoria'
                    ),
                    trailing: GestureDetector(
                      onTap: () => removerTarefa(index),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: adicionarTarefa,
        shape: CircleBorder(), //deixa o botão redondo
        child: Icon(Icons.add),
      ),
    );
  }
}
