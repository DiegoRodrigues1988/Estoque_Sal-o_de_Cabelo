import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Models
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/models/venda_model.dart';
import 'package:estoque_salao_de_cabelo/models/agendamento_model.dart';

// Providers
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/venda_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/agendamento_provider.dart';

// UI
// A nova porta de entrada do app
import 'package:estoque_salao_de_cabelo/ui/pages/auth_check_page.dart';
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  await Hive.initFlutter();

  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(ProdutoAdapter());
  Hive.registerAdapter(VendaAdapter());
  Hive.registerAdapter(AgendamentoAdapter());

  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Produto>('produtos');
  await Hive.openBox<Venda>('vendas');
  await Hive.openBox<Agendamento>('agendamentos');

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
        ChangeNotifierProvider(create: (_) => AgendamentoProvider()),
      ],
      child: MaterialApp(
        title: 'Gestor de Salão',
        theme: AppTheme.themeData,

        // Configuração de idioma para português
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // --- MUDANÇA PRINCIPAL AQUI ---
        // A tela inicial agora é a de checagem de autenticação.
        home: const AuthCheckPage(),

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
