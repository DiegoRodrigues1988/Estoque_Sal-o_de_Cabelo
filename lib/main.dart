import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/models/venda_model.dart';

// Providers
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';

// UI
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

void main() async {
  // Garante que o Flutter está inicializado antes de usar plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive para armazenamento local
  await Hive.initFlutter();

  // Registra os adaptadores para cada modelo de dados
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(ProdutoAdapter());
  Hive.registerAdapter(VendaAdapter()); // Adicionado o adaptador de Venda

  // Abre as "caixas" (tabelas) do banco de dados
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Produto>('produtos');
  await Hive.openBox<Venda>('vendas'); // Adicionada a caixa de Vendas

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider disponibiliza os providers para toda a árvore de widgets do app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ProdutoProvider()),
        ChangeNotifierProvider(
            create: (_) => VendaProvider()), // Adicionado o VendaProvider
      ],
      child: MaterialApp(
        title: 'Gestor de Salão',
        theme: AppTheme.themeData,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
