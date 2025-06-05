import 'package:flutter/material.dart';
import 'package:manutencao_veiculos/controllers/veiculo_controller.dart';
import 'package:manutencao_veiculos/models/veiculo_model.dart';

class DetalheVeiculoScreen extends StatefulWidget{
  final int VeiculoId;

  //construtor -> pega o Id
  const DetalheVeiculoScreen({
    super.key, required this.veiculoId
  });

  @override
  State<StatefulWidget> createState() {
    return _DetalheVeiculoScreenState();
  }
}

class _DetalheVeiculoScreenState extends State<DetalheVeiculoScreen>{
  //build da Tela
  //atributos
  final VeiculoController _veiculoController = VeiculoController();
  final ManutencaoController _manutencaoController = ManutencaoController();

  bool _isLoading = true;

  Veiculo? _veiculo; //pode ser inicialmente nulo

  List<Manutencao> _manutencao = [];
