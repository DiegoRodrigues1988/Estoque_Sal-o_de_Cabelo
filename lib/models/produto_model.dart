import 'package:hive/hive.dart';

part 'produto_model.g.dart';

@HiveType(typeId: 1)
class Produto extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  String categoria;

  @HiveField(3)
  int quantidade;

  @HiveField(4)
  double precoCusto;

  @HiveField(5)
  double precoVenda;

  // --- NOVO CAMPO ADICIONADO ---
  @HiveField(6)
  DateTime dataAdicao;

  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    required this.precoCusto,
    required this.precoVenda,
    required this.dataAdicao, // Adicionado ao construtor
  });
}
