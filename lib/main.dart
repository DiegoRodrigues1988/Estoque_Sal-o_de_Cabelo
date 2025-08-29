import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

// Models
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/models/venda_model.dart';
import 'package:estoque_salao_de_cabelo/models/agendamento_model.dart'; // <-- 1. IMPORTAR

// Providers
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/agendamento_provider.dart'; // <-- 2. IMPORTAR

// UI
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  await Hive.initFlutter();

  // Registra todos os adaptadores
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(ProdutoAdapter());
  Hive.registerAdapter(VendaAdapter());
  Hive.registerAdapter(AgendamentoAdapter()); // <-- 3. REGISTRAR NOVO ADAPTADOR

  // Abre todas as caixas
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Produto>('produtos');
  await Hive.openBox<Venda>('vendas');
  await Hive.openBox<Agendamento>('agendamentos'); // <-- 4. ABRIR NOVA CAIXA

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
        ChangeNotifierProvider(
            create: (_) =>
                AgendamentoProvider()), // <-- 5. ADICIONAR NOVO PROVIDER
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
