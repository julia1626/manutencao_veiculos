import 'package:flutter/material.dart';
import 'package:manutencao_veiculos/controllers/veiculo_controller.dart';
import 'package:manutencao_veiculos/models/veiculo_model.dart';
import 'package:manutencao_veiculos/view/home_screen.dart';

class CadastroVeiculoScreen extends StatefulWidget {
  //tela dinamica - mudanças de estado deposi da construção inicial
  @override
  State<StatefulWidget> createState() => _CadastroVeiculoScreenState(); //chama a mudança
}

class _CadastroVeiculoScreenState extends State<CadastroVeiculoScreen> {
  // faz a build da Tela
  //atributos
  final _formKey = GlobalKey<FormState>(); //chave para armazenamento dos valores do Formulário
  final _controllerVeiculo = VeiculoController();

  // atributos do obj
  late String _marca;
  late String _modelo;
  late String _ano;
  late String _placa;
  late String _inicial;
 
  Future<void> _salvarVeiculo() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      final newVeiculo = Veiculo(
        marca: _marca, 
        modelo: _modelo, 
        ano: _ano, 
        placa: _placa,
        inicial: _inicial);
      //mardar as info para o DB
      await _controllerVeiculo.createVeiculo(newVeiculo);
      //volta Para a Tela Inicial
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())); 

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo Veículo"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Marca do Veículo"),
                validator: (value)=> value!.isEmpty ? "Campo não Preenchido!!!": null,
                onSaved: (value) => _marca= value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Modelo do Veículo"),
                validator: (value)=> value!.isEmpty ? "Campo não Preenchido!!!": null,
                onSaved: (value) => _modelo= value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Ano do Veículo"),
                validator: (value)=> value!.isEmpty ? "Campo não Preenchido!!!": null,
                onSaved: (value) => _ano= value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Placa do Veículo"),
                validator: (value)=> value!.isEmpty ? "Campo não Preenchido!!!": null,
                onSaved: (value) => _placa= value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Quilometragem inicial do Veículo"),
                validator: (value)=> value!.isEmpty ? "Campo não Preenchido!!!": null,
                onSaved: (value) => _inicial= value!,
              ),
              ElevatedButton(onPressed: _salvarVeiculo, child: Text("Cadastrar Veículo"))
            ],
          )
          ),
        ),
    );
  }
}