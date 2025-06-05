class VeiculoDbhelper {
  // fazer conexão singleton
  static Database? _database; // obj SQlite conexão com BD

  //classe do tipo Singleton
  static final VeiculoDbhelper _instance = VeiculoDbhelper._internal();

  VeiculoDbhelper._internal();
  factory VeiculoDbhelper() {
    return _instance;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "veiculo.db");

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    // Cria a tabela 'veiculos'
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
    print("banco veiculos criado");

    //continua..