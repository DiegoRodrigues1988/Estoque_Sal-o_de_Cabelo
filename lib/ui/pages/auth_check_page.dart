import 'package:flutter/material.dart';
import 'package:estoque_salao_de_cabelo/services/auth_service.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/create_pin_page.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/login_page.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final hasPin = await _authService.hasPin();
    if (mounted) {
      if (hasPin) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const CreatePinPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tela de carregamento enquanto verificamos
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
