import 'package:hive/hive.dart';

part 'cliente_model.g.dart';

@HiveType(typeId: 0)
class Cliente extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  String telefone;

  // NOVO CAMPO DE EMAIL
  @HiveField(3)
  String? email; // '?' significa que o email é opcional

  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.email, // Adicionado ao construtor
  });
}
