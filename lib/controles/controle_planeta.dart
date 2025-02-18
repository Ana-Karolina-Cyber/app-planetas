import 'dart:async';
import 'package:myapp/modelos/planeta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ControlePlaneta {
  static Database? _db;

  Future<Database?> get bd async {
    if (_db != null) return _db!;
    _db = await _iniciarBD('planetas.db');
    return _db;
  }

  Future<Database> _iniciarBD(String nomeBd) async {
    final caminhoBd = await getDatabasesPath();
    final caminho = join(caminhoBd, nomeBd);
    return await openDatabase(caminho, version: 1, onCreate: _criarBD);
  }

  FutureOr<void> _criarBD(Database db, int version) async {
    const sql = ''' 
              CREATE TABLE planetas(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                tamanho REAL NOT NULL,
                distancia REAL NOT NULL,
                apelido TEXT NOT NULL
              )

              ''';
    await db.execute(sql);
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db!.insert('planetas', planeta.toMap());
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db!.update('planetas', planeta.toMap(),
        where: 'id = ?', whereArgs: [planeta.id]);
  }

  Future<List<Planeta>> lerPlaneta() async {
    final db = await bd;
    final lista = await db!.query('planetas');
    return lista.map((map) => Planeta.fromMap(map)).toList();
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db!.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }
}