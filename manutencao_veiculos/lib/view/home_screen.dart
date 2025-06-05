import 'package:flutter/material.dart';
import 'package:manutencao_veiculos/controllers/veiculo_controller.dart';
import 'package:manutencao_veiculos/models/veiculo_model.dart';
import 'package:manutencao_veiculos/view/cadastro_veiculo_screen.dart';

class HomeScreen extends StatefulWidget{
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

  @override //carrega o método antes de construir a tela. se tiver dados no banco já buscar as info
  void initState() {
    // TODO: implement initState
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao Carregar os Dados $e")));
    } finally { //execução obrigatória independente  do resultado
      setState(() {
        _isLoading = false;
      });
    }
  }

//build da Tela
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Meu Veículo - Cliente"),),
      body: _isLoading //operador ternário
        ? Center(child: CircularProgressIndicator(),)
        : Padding(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: _veiculos.length,
            itemBuilder: (context,index){
              final veiculo = _veiculos[index];
              return ListTile(
                title: Text("${veiculo.marca} - ${veiculo.modelo}"),
                subtitle: Text("${veiculo.ano} - ${veiculo.placa} - ${veiculo.inicial}"),
                onTap: () => Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>DetalheVeiculoScreen(veiculoId: veiculo.id!))), //página de detalhes do PET
              onLongPress: () => _deleteVeiculo(veiculo.id!),
              );
            }),
          ),
          floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: 
        (context)=> CadastroVeiculoScreen())),
        tooltip: "Adicionar Novo Veículo",
        child: Icon(Icons.add),
        ),
    );
  }

  void _deleteVeiculo(int id) async {
    try {
      await _controllerVeiculo._deleteVeiculo(id);
      await _controllerVeiculo.readVeiculos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veículo Deletado com Sucesso"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e"))
      );
      
    }
  }
}