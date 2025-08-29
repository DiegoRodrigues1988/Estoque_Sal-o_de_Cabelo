import 'package:flutter/material.dart';
import 'package:estoque_salao_de_cabelo/services/auth_service.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/reset_pin_page.dart'; // Importar a nova tela

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _pinController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorText;

  void _login() async {
    if (_pinController.text.length == 4) {
      final isCorrect = await _authService.checkPin(_pinController.text);
      if (isCorrect) {
        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } else {
        setState(() {
          _errorText = 'PIN incorreto. Tente novamente.';
          _pinController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_open_outlined, size: 60),
            const SizedBox(height: 24),
            const Text('Digite seu PIN',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            const SizedBox(height: 32),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 16),
              decoration: InputDecoration(
                counterText: '',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 16),
            // --- NOVO BOTÃO DE RECUPERAÇÃO ---
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ResetPinPage()));
              },
              child: const Text('Esqueci meu PIN'),
            )
          ],
        ),
      ),
    );
  }
}
