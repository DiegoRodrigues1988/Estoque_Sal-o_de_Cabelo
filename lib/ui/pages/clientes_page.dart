import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/add_edit_cliente_page.dart';
import 'package:intl/intl.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clienteProvider = Provider.of<ClienteProvider>(context);
    final clientes = clienteProvider.clientes;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: clientes.isEmpty
          ? const Center(child: Text('Nenhum cliente cadastrado.'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(cliente.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(cliente.telefone),
                    trailing: Text(
                        'Últ. Visita:\n${DateFormat('dd/MM/yy').format(cliente.ultimaVisita)}',
                        textAlign: TextAlign.center),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditClientePage(cliente: cliente)),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditClientePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
