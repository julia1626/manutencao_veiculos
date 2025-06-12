import 'package:manutencao_veiculos/models/manutencao_model.dart';
import 'package:manutencao_veiculos/models/veiculo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeiculoDbhelper {
  static Database? _database;
  static final VeiculoDbhelper _instance = VeiculoDbhelper._internal();

  VeiculoDbhelper._internal();
  factory VeiculoDbhelper() => _instance;

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "veiculo.db");

    return await openDatabase(
      path,
      version: 2, // aumente a versão para forçar o onUpgrade se necessário
      onCreate: _onCreateDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  Future<void> _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS veiculos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        marca TEXT,
        modelo TEXT,
        ano TEXT,
        placa TEXT,
        inicial TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS manutencoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        veiculo_id INTEGER,
        data_hora TEXT,
        tipo_manutencao TEXT,
        observacao TEXT,
        custo TEXT,
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id) ON DELETE CASCADE
      )
    ''');
  }

  // Adiciona colunas se estiver atualizando de versões antigas
  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE manutencoes ADD COLUMN custo TEXT');
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // CRUD - Veículos
  Future<int> insertVeiculo(Veiculo veiculo) async {
    final db = await database;
    return db.insert("veiculos", veiculo.toMap());
  }

  Future<List<Veiculo>> getVeiculos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("veiculos");
    return maps.map((e) => Veiculo.fromMap(e)).toList();
  }

  Future<Veiculo?> getVeiculoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "veiculos",
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Veiculo.fromMap(maps.first);
  }

  Future<int> deleteVeiculo(int id) async {
    final db = await database;
    return await db.delete("veiculos", where: "id = ?", whereArgs: [id]);
  }

  // CRUD - Manutenções
  Future<int> insertManutencao(Manutencao manutencao) async {
    final db = await database;
    return await db.insert("manutencoes", manutencao.toMap());
  }

  Future<List<Manutencao>> getManutencoesForVeiculo(int veiculoId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "manutencoes",
      where: "veiculo_id = ?",
      whereArgs: [veiculoId],
    );
    return maps.map((e) => Manutencao.fromMap(e)).toList();
  }

  Future<int> deleteManutencao(int id) async {
    final db = await database;
    return db.delete("manutencoes", where: "id = ?", whereArgs: [id]);
  }
}
