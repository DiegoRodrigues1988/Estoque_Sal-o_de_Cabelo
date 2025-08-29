import 'package:flutter/foundation.dart'; // <-- A CORREÇÃO ESTÁ NESTA LINHA
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:estoque_salao_de_cabelo/models/agendamento_model.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';

class AgendamentoProvider with ChangeNotifier {
  final Box<Agendamento> _agendamentosBox =
      Hive.box<Agendamento>('agendamentos');
  List<Agendamento> _agendamentos = [];

  List<Agendamento> get agendamentos => _agendamentos;

  AgendamentoProvider() {
    loadAgendamentos();
  }

  void loadAgendamentos() {
    _agendamentos = _agendamentosBox.values.toList();
    _agendamentos.sort((a, b) => a.data.compareTo(b.data)); // Ordena por data
    notifyListeners();
  }

  Future<void> addAgendamento(Cliente cliente, DateTime data) async {
    final novoAgendamento = Agendamento(
      id: const Uuid().v4(),
      clienteId: cliente.id,
      clienteNome: cliente.nome,
      data: data,
    );
    await _agendamentosBox.put(novoAgendamento.id, novoAgendamento);
    loadAgendamentos();
  }

  Future<void> deleteAgendamento(Agendamento agendamento) async {
    await agendamento.delete();
    loadAgendamentos();
  }
}
