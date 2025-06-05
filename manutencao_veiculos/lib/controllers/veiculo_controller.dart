class VeiculoController {
  final VeiculoDBHelper _dbHelper = VeiculoDBHelper();

  Future<int> createVeiculo(Veiculo veiculo) async{
    return _dbHelper.insertVeiculo(veiculo);
  }

  Future<List<Veiculo>> readVeiculos() async{
    return _dbHelper.getVeiculos();
  }

  Future<Veiculo?> readVeiculoById(int id) async{
    return _dbHelper.getVeiculoById(id);
  }

  Future<int> _deleteVeiculo(int id) async{
    return _dbHelper._deleteVeiculo(id);
  }
}