import 'package:flutter/material.dart';
import 'package:manutencao_veiculos/controllers/manutencao_controller.dart';
import 'package:manutencao_veiculos/controllers/veiculo_controller.dart';
import 'package:manutencao_veiculos/models/manutencao_model.dart';
import 'package:manutencao_veiculos/models/veiculo_model.dart';
import 'package:manutencao_veiculos/view/registro_manutencao_screen.dart';

class DetalheVeiculoScreen extends StatefulWidget {
  final int veiculoId;

  const DetalheVeiculoScreen({super.key, required this.veiculoId});

  @override
  State<DetalheVeiculoScreen> createState() => _DetalheVeiculoScreenState();
}

class _DetalheVeiculoScreenState extends State<DetalheVeiculoScreen> {
  final VeiculoController _veiculoController = VeiculoController();
  final ManutencaoController _manutencaoController = ManutencaoController();

  bool _isLoading = true;
  Veiculo? _veiculo;
  List<Manutencao> _manutencoes = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);

    try {
      final veiculo = await _veiculoController.readVeiculoById(widget.veiculoId);
      final manutencoes = await _manutencaoController.readManutencaoForVeiculo(widget.veiculoId);

      setState(() {
        _veiculo = veiculo;
        _manutencoes = manutencoes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteManutencao(int manutencaoId) async {
    try {
      await _manutencaoController.deleteManutencao(manutencaoId);
      await _carregarDados();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Manutenção deletada com sucesso")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Veículo"),
        backgroundColor: Color(0xFFB388EB),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEDCFA),
              Color(0xFFD6B3FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _veiculo == null
                ? Center(child: Text("Erro ao carregar o veículo."))
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Marca: ${_veiculo!.marca}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple)),
                                SizedBox(height: 4),
                                Text("Modelo: ${_veiculo!.modelo}",
                                    style: TextStyle(fontSize: 16)),
                                Text("Ano: ${_veiculo!.ano}"),
                                Text("Placa: ${_veiculo!.placa}"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Manutenções:",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: _manutencoes.isEmpty
                              ? Center(
                                  child: Text(
                                    "Não existem registros de manutenção.",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _manutencoes.length,
                                  itemBuilder: (context, index) {
                                    final manutencao = _manutencoes[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(
                                          manutencao.tipoManutencao,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Data: ${manutencao.dataHoraFormatada}"),
                                            Text("Custo: R\$ ${manutencao.custo}"),
                                            if (manutencao.observacao
                                                .trim()
                                                .isNotEmpty)
                                              Text(
                                                  "Obs: ${manutencao.observacao}"),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _deleteManutencao(manutencao.id!),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFB388EB),
        child: Icon(Icons.add),
        tooltip: "Registrar manutenção",
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistroManutencaoScreen(
                veiculoId: widget.veiculoId,
              ),
            ),
          );
          _carregarDados();
        },
      ),
    );
  }
}
