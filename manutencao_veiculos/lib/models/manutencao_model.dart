import 'package:intl/intl.dart';

class Manutencao {
  final int? id;
  final int veiculoId;
  final DateTime dataHora;
  final String tipoManutencao;
  final String observacao;
  final String custo;

  Manutencao({
    this.id,
    required this.veiculoId,
    required this.dataHora,
    required this.tipoManutencao,
    required this.observacao,
    required this.custo,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "veiculo_id": veiculoId,
      "data_hora": dataHora.toIso8601String(),
      "tipo_manutencao": tipoManutencao,
      "observacao": observacao,
      "custo": custo,
    };
  }

  factory Manutencao.fromMap(Map<String, dynamic> map) {
    return Manutencao(
      id: map["id"] != null ? map["id"] as int : null,
      veiculoId: map["veiculo_id"] as int,
      dataHora: DateTime.parse(map["data_hora"] as String),
      tipoManutencao: map["tipo_manutencao"] as String,
      observacao: map["observacao"] as String,
      custo: map["custo"].toString(),
    );
  }

  String get dataHoraFormatada {
    final DateFormat formatter = DateFormat("dd/MM/yyyy");
    return formatter.format(dataHora);
  }
}
