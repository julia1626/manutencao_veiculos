import 'package:manutencao_veiculos/models/manutencao_model.dart';
import 'package:manutencao_veiculos/services/veiculo_dbhelper.dart';

class ManutencaoController {
  final _dbHelper = VeiculoDbhelper();

  //métodos do Crud

  //retrona o nº do id que foi inserido
  Future<int> createManutencao(Manutencao manutencao) async{
    return _dbHelper.insertManutencao(manutencao);
  }

  Future<List<Manutencao>> readManutencaoForVeiculo(int veiculoId) async{
    return _dbHelper.getManutencoesForVeiculo(veiculoId);
  }
  //retrona o id
  Future<int> deleteManutencao(int id) async{
    return _dbHelper.deleteManutencao(id);
  }
}