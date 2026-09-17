import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async{
    _db ??= await abrirBanco();
    return _db!;
  }

  //Abre(ou cria, se não existir) o arquivo do banco de dados
  static Future<Database> abrirBanco() async{

    final caminho = join(await getDatabasesPath(), 'tarefas.db');
    
    
    return openDatabase(
      caminho,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE tarefas (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            titulo TEXT , 
            situacao INTEGER,
            categoria TEXT
            )
          
          ''',
        );
      },
      onUpgrade: (db, versaoAntiga, versaoNova) {
        if(versaoAntiga < 2){
          db.execute('ALTER TABLE tarefas ADD COLUMN categoria TEXT');
        }
      },
    );
  }

  //READ: Buscar todas as tarefas salvas no banco de dados
  static Future<List<Map<String, dynamic>>> buscarTarefas({
    String? filtro   // quando coloca {} deixa opcional o parametro
    }) async{
    final db = await DatabaseHelper.database;

    if(filtro == 'pendentes'){
      // SELECT * FROM tarefas WHERE situacao = 0
      return db.query(
        'tarefas',
        where: 'situacao = 0',
      );
    } else if(filtro == 'concluidos'){
      // SELECT * FROM tarefas WHERE situacao = 1
      return db.query(
        'tarefas',
        where: 'situacao = 1',
      );
    }
    return db.query('tarefas');
  }

  //Create: Inserir tarefa no banco de dados
  static Future<void> inserirTarefa(String titulo, String categoria) async{
    final db = await DatabaseHelper.database;
    await db.insert('tarefas', {
        'titulo':titulo,
        'situacao':0, //0 = False, 1 = verdadeiro (SQLite não tem boolean)
        'categoria': categoria,
    });
  }

  //Update: Alterar o campo marcado da tarefa
  static Future<void> atualizarSituacao(int id, int situacao) async{

    final db = await DatabaseHelper.database;
    await db.update(
      'tarefas',
      { 'situacao': situacao},
      where: 'id = ?',
      whereArgs: [id],

      ); 
  }

  //Delete: Remover uma tarefa
  static Future<void> removerSituacao(int id) async{

    final db = await DatabaseHelper.database;
    await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],

      ); 
  }
}