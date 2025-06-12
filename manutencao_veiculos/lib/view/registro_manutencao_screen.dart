import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manutencao_veiculos/controllers/manutencao_controller.dart';
import 'package:manutencao_veiculos/models/manutencao_model.dart';

class RegistroManutencaoScreen extends StatefulWidget {
  final int veiculoId;

  const RegistroManutencaoScreen({super.key, required this.veiculoId});

  @override
  State<RegistroManutencaoScreen> createState() => _RegistroManutencaoScreenState();
}

class _RegistroManutencaoScreenState extends State<RegistroManutencaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _manutencaoController = ManutencaoController();

  late String _tipoManutencao;
  late String _observacao;
  late String _custo;
  DateTime _dataSelecionada = DateTime.now();

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Future<void> _salvarRegistro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final novaManutencao = Manutencao(
        veiculoId: widget.veiculoId,
        dataHora: DateTime(
          _dataSelecionada.year,
          _dataSelecionada.month,
          _dataSelecionada.day,
        ),
        tipoManutencao: _tipoManutencao,
        custo: _custo,
        observacao: _observacao.isEmpty ? "Nenhuma Observação" : _observacao,
      );

      try {
        await _manutencaoController.createManutencao(novaManutencao);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro realizado com sucesso")),
        );
        Navigator.pop(context); // volta para a tela anterior (DetalheVeiculoScreen)
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar registro: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataFormatada = DateFormat("dd/MM/yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Registro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Tipo de Serviço"),
                validator: (value) => value == null || value.isEmpty
                    ? "Preencha o tipo de serviço"
                    : null,
                onSaved: (value) => _tipoManutencao = value!,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Data: ${dataFormatada.format(_dataSelecionada)}"),
                  TextButton(
                    onPressed: () => _selecionarData(context),
                    child: Text("Selecionar Data"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Observação"),
                onSaved: (value) => _observacao = value ?? "",
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Custo"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value == null || value.isEmpty ? "Preencha o custo" : null,
                onSaved: (value) => _custo = value!,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarRegistro,
                child: Text("Criar Registro"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
