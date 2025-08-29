import 'package:flutter/foundation.dart';
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
    _agendamentos.sort((a, b) => a.data.compareTo(b.data));
    notifyListeners();
  }

  Future<void> addAgendamento(Cliente cliente, DateTime data) async {
    final novoAgendamento = Agendamento(
      id: const Uuid().v4(),
      clienteId: cliente.id,
      clienteNome: cliente.nome,
      data: data,
      status: 'agendado', // Status inicial
    );
    await _agendamentosBox.put(novoAgendamento.id, novoAgendamento);
    loadAgendamentos();
  }

  Future<void> deleteAgendamento(Agendamento agendamento) async {
    await agendamento.delete();
    loadAgendamentos();
  }

  // --- NOVAS FUNÇÕES DE STATUS ---
  Future<void> concluirAgendamento(Agendamento agendamento) async {
    agendamento.status = 'concluido';
    await agendamento.save();
    loadAgendamentos();
  }

  Future<void> cancelarAgendamento(Agendamento agendamento) async {
    agendamento.status = 'cancelado';
    await agendamento.save();
    loadAgendamentos();
  }
}
