import 'package:flutter/material.dart';
import 'package:manutencao_veiculos/controllers/veiculo_controller.dart';
import 'package:manutencao_veiculos/models/veiculo_model.dart';
import 'package:manutencao_veiculos/view/cadastro_veiculo_screen.dart';
import 'package:manutencao_veiculos/view/detalhe_veiculo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final VeiculoController _controllerVeiculo = VeiculoController();
  List<Veiculo> _veiculos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() {
      _isLoading = true;
    });
    _veiculos = [];
    try {
      _veiculos = await _controllerVeiculo.readVeiculos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao Carregar os Dados: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Veículo - Cliente"),
        backgroundColor: Color(0xFFB388EB), // tom de lilás
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEDCFA), // lilás claro
              Color(0xFFD6B3FF), // lilás médio
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: _veiculos.length,
                  itemBuilder: (context, index) {
                    final veiculo = _veiculos[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          "${veiculo.marca} - ${veiculo.modelo}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        subtitle: Text(
                          "${veiculo.ano} • ${veiculo.placa} • ${veiculo.inicial}",
                          style: TextStyle(color: Colors.black54),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalheVeiculoScreen(
                              veiculoId: veiculo.id!,
                            ),
                          ),
                        ),
                        onLongPress: () => _deleteVeiculo(veiculo.id!),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CadastroVeiculoScreen()),
        ),
        tooltip: "Adicionar Novo Veículo",
        backgroundColor: Color(0xFFB388EB),
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteVeiculo(int id) async {
    try {
      await _controllerVeiculo.deleteVeiculo(id);
      _carregarDados(); // Atualiza a lista após deletar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veículo deletado com sucesso")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar veículo: $e")),
      );
    }
  }
}
