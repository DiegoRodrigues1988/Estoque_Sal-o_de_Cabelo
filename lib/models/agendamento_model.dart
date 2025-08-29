import 'package:hive/hive.dart';

part 'agendamento_model.g.dart';

@HiveType(typeId: 3) // Novo typeId, precisa ser único
class Agendamento extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String clienteId; // Para saber a qual cliente pertence

  @HiveField(2)
  String clienteNome;

  @HiveField(3)
  DateTime data; // Data e hora do agendamento

  Agendamento({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.data,
  });
}
