import 'package:hive/hive.dart';

part 'venda_model.g.dart';

@HiveType(typeId: 2) // Novo typeId
class Venda extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String produtoId;

  @HiveField(2)
  final String produtoNome;

  @HiveField(3)
  final int quantidade;

  @HiveField(4)
  final double totalCusto; // (quantidade * precoCusto)

  @HiveField(5)
  final double totalVenda; // (quantidade * precoVenda)

  @HiveField(6)
  final DateTime dataVenda;

  double get lucro => totalVenda - totalCusto;

  Venda({
    required this.id,
    required this.produtoId,
    required this.produtoNome,
    required this.quantidade,
    required this.totalCusto,
    required this.totalVenda,
    required this.dataVenda,
  });
}
