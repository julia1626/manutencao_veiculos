class Manutencao {
  //atributos
  final int? id;
  final int veiculoId;
  final DateTime dataHora; // obj é dateTime -> BD é string 
  final String tipoManutencao;
  final String observacao;

  //construtor
  Manutencao({
    this.id,
    required this.veiculoId,
    required this.dataHora,
    required this.tipoManutencao,
    required this.observacao
  });

  //toMap - obj -> BD
  Map<String,dynamic> toMap(){
    return{
      "id":id,
      "veiculo_id":veiculoId,
      "data_hora":dataHora.toIso8601String(),
      "tipo_manutencao": tipoManutencao,
      "observacao":observacao
    };
  }

  //fromMap() - BD -> Obj
  factory Manutencao.fromMap(Map<String,dynamic> map){
    return Manutencao(
      id: map["id"] as int, //cast
      veiculoId: map["veiculo_id"] as int, 
      dataHora: DateTime.parse(map["data_hora"] as String), //converter String em Formato de DateTime
      tipoManutencao: map["tipo_manutencao"] as String,
      observacao: map["observacao"] as String); //pode ser nulo
  }

  // método formatar data e hora em formato Brasil
  String get dataHoraFormatada{
    final DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm");
    return formatter.format(dataHora);
  }

}