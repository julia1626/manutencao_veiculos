class Veiculo{
  //atributos
  final int? id; //permite ser nulo
  final String marca;
  final String modelo;
  final String ano;
  final String placa;
  final String inicial;

  Veiculo({
    this.id,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.inicial,
  });

  //métodos do conversão -> obj-> BD : BD->obj

  Map<String,dynamic> toMap(){
    return{
      "id": id,
      "marca":marca,
      "modelo":modelo,
      "ano": ano,
      "placa": placa,
      "inicial": inicial
    };
  }

  factory Veiculo.fromMap(Map<String,dynamic> map) {
    return Veiculo(
      id:map["id"] as int,
      marca: map["marca"] as String, 
      modelo: map["modelo"] as String, 
      ano: map["ano"] as String, 
      placa: map["placa"] as String,
      inicial: map["inicial"] as String);
  }

}