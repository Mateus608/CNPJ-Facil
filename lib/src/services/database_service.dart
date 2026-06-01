import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cnpj_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'cnpj_facil.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE historico_consultas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cnpj TEXT NOT NULL,
            abertura TEXT,
            nome TEXT,
            fantasia TEXT,
            tipo TEXT,
            porte TEXT,
            natureza_juridica TEXT,
            atividade_principal TEXT,
            situacao TEXT,
            data_situacao TEXT,
            capital_social TEXT,
            logradouro TEXT,
            numero TEXT,
            complemento TEXT,
            bairro TEXT,
            municipio TEXT,
            uf TEXT,
            cep TEXT,
            email TEXT,
            telefone TEXT,
            data_consulta TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> salvarConsulta(CnpjModel empresa) async {
    final db = await database;
    return db.insert('historico_consultas', empresa.toMap());
  }

  Future<List<CnpjModel>> listarHistorico() async {
    final db = await database;
    final result = await db.query(
      'historico_consultas',
      orderBy: 'id DESC',
    );
    return result.map(CnpjModel.fromMap).toList();
  }

  Future<int> limparHistorico() async {
    final db = await database;
    return db.delete('historico_consultas');
  }
}
