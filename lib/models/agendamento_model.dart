import 'package:hive/hive.dart';

part 'agendamento_model.g.dart';

@HiveType(typeId: 3)
class Agendamento extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String clienteId;

  @HiveField(2)
  String clienteNome;

  @HiveField(3)
  DateTime data;

  // NOVO CAMPO DE STATUS
  @HiveField(4)
  String status; // 'agendado', 'concluido', 'cancelado'

  Agendamento({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.data,
    required this.status,
  });
}
