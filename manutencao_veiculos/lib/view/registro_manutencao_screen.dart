import 'package:flutter/material.dart';
import 'package:manutencao_veiculos/controllers/manutencao_controller.dart';
import 'package:manutencao_veiculos/models/manutencao_model.dart';
import 'package:manutencao_veiculos/view/detalhe_veiculo_screen.dart';

class RegistroManutencaoScreen extends StatefulWidget {
  //atributo
  final int veiculoId;

  RegistroManutencaoScreen({super.key, required this.veiculoId});

  @override
  State<StatefulWidget> createState() {
    return _RegistroManutencaoSreenState();
  }
}

class _RegistroManutencaoSreenState extends State<RegistroManutencaoScreen>{
  final _formKey = GlobalKey<FormState>();
  final _manutencaoController = ManutencaoController();

  late String _tipoManutencao; // recebe o valor posteriormente
  late String _inicial;
  late String _custo;
  late String _observacao;
  DateTime _dataSelecionada = DateTime.now(); //pega o dia Atual

  //método para Selecionar Data
  _selecionarData(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030));
    if(picked != null && picked != _dataSelecionada){
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

   _salvarRegistro() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save(); //salvo as informações do formulário nas váriaveis selecioanda anteriormente

      final DateTime dataRegistro = DateTime(
        _dataSelecionada.year,
        _dataSelecionada.month,
        _dataSelecionada.day);

        final newRegistro = Registro(
        veiculoId: widget.veiculoId, 
        dataHora: dataRegistro, 
        tipoManutencao: _tipoManutencao, 
        observacao: _observacao.isEmpty ? "Nenhuma Observação" : _observacao);
      
      //Armazenar no BD
      try {
        await _manutencaoController.createManutencao(newManutencao);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro Realizado com Sucesso")));
        Navigator.push(context, 
          MaterialPageRoute(builder: (context)=>DetalheVeiculoScreen(veiculoId: widget.veiculoId)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e")));
      }
    }
  }