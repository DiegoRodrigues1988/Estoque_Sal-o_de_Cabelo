import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- 1. IMPORTAR ESTA LINHA

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
  WidgetsFlutterBinding.ensureInitialized();

  // --- CORREÇÃO AQUI ---
  // 2. INICIALIZAR A FORMATAÇÃO DE DATAS PARA O NOSSO IDIOMA
  await initializeDateFormatting('pt_BR', null);

  await Hive.initFlutter();

  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(ProdutoAdapter());
  Hive.registerAdapter(VendaAdapter());

  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Produto>('produtos');
  await Hive.openBox<Venda>('vendas');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ProdutoProvider()),
        ChangeNotifierProvider(create: (_) => VendaProvider()),
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
