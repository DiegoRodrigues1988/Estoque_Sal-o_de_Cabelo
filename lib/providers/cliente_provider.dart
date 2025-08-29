import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';

class ClienteProvider with ChangeNotifier {
  final Box<Cliente> _clientesBox = Hive.box<Cliente>('clientes');
  List<Cliente> _clientes = [];

  List<Cliente> get clientes => _clientes;

  ClienteProvider() {
    loadClientes();
  }

  void loadClientes() {
    _clientes = _clientesBox.values.toList();
    _clientes
        .sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    notifyListeners();
  }

  Future<void> addCliente(String nome, String telefone, String? email) async {
    final novoCliente = Cliente(
      id: const Uuid().v4(),
      nome: nome,
      telefone: telefone,
      email: email,
    );
    await _clientesBox.put(novoCliente.id, novoCliente);
    loadClientes();
  }

  Future<void> updateCliente(
      Cliente cliente, String nome, String telefone, String? email) async {
    cliente.nome = nome;
    cliente.telefone = telefone;
    cliente.email = email;
    await cliente.save();
    loadClientes();
  }

  Future<void> deleteCliente(Cliente cliente) async {
    await cliente.delete();
    loadClientes();
  }
}
