import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:estoque_salao_de_cabelo/models/cliente_model.dart';
import 'package:estoque_salao_de_cabelo/models/produto_model.dart';
import 'package:estoque_salao_de_cabelo/providers/cliente_provider.dart';
import 'package:estoque_salao_de_cabelo/providers/produto_provider.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';
import 'package:estoque_salao_de_cabelo/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(ProdutoAdapter());

  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Produto>('produtos');

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
