import 'package:manutencao_veiculos/models/veiculo_model.dart';
import 'package:manutencao_veiculos/services/veiculo_dbhelper.dart';

class VeiculoController {
  final VeiculoDbhelper _dbHelper = VeiculoDbhelper();

  Future<int> createVeiculo(Veiculo veiculo) async{
    return _dbHelper.insertVeiculo(veiculo);
  }

  Future<List<Veiculo>> readVeiculos() async{
    return _dbHelper.getVeiculos();
  }

  Future<Veiculo?> readVeiculoById(int id) async{
    return _dbHelper.getVeiculoById(id);
  }

  Future<int> deleteVeiculo(int id) async{
    return _dbHelper.deleteVeiculo(id);
  }
}