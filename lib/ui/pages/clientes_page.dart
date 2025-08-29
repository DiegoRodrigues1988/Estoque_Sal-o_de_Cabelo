import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/add_edit_cliente_page.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  void _confirmarExclusao(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir "${cliente.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ClienteProvider>(context, listen: false)
                  .deleteCliente(cliente);
              Navigator.of(ctx).pop();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para que a lista se atualize automaticamente
    return Consumer<ClienteProvider>(
      builder: (context, provider, child) {
        final clientes = provider.clientes;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Clientes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddEditClientePage())),
              ),
            ],
          ),
          body: clientes.isEmpty
              ? const Center(child: Text('Nenhum cliente cadastrado.'))
              : ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(cliente.nome,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(cliente
                            .telefone), // Mostra o telefone como subtítulo
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => _confirmarExclusao(context, cliente),
                        ),
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
        );
      },
    );
  }
}
