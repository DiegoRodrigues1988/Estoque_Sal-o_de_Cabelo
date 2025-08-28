import 'package:flutter/material.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/clientes_page.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/estoque_page.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/contabilidade_page.dart'; // <-- IMPORTAR A NOVA PÁGINA
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de Salão')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.people_outline,
              label: 'Clientes',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ClientesPage())),
            ),
            _buildMenuCard(
              context,
              icon: Icons.inventory_2_outlined,
              label: 'Estoque',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EstoquePage())),
            ),
            // --- NOVO CARD ADICIONADO AQUI ---
            _buildMenuCard(
              context,
              icon: Icons.monetization_on_outlined,
              label: 'Contabilidade',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ContabilidadePage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppTheme.accentGold),
            const SizedBox(height: 12),
            Text(label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
