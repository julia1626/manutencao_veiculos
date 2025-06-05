class ManutencaoController {
  final _dbHelper = VeiculoDBHelper();

  //métodos do Crud

  //retrona o nº do id que foi inserido
  Future<int> createManutencao(Manutencao manutencao) async{
    return _dbHelper.insertManutencao(manutencao);
  }

  Future<List<Manutencao>> readManutencaoForVeiculo(int veiculoId) async{
    return _dbHelper.getManutencaoForVeiculo(veiculoId);
  }
  //retrona o id
  Future<int> deleteManutencao(int id) async{
    return _dbHelper.deleteManutencao(id);
  }
}