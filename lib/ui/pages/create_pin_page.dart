import 'package:flutter/material.dart';
import 'package:estoque_salao_de_cabelo/services/auth_service.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';

class CreatePinPage extends StatefulWidget {
  const CreatePinPage({super.key});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  final _pinController = TextEditingController();
  final AuthService _authService = AuthService();

  void _savePin() async {
    if (_pinController.text.length == 4) {
      await _authService.savePin(_pinController.text);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
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
            const Icon(Icons.lock_outline, size: 60),
            const SizedBox(height: 24),
            const Text('Crie seu PIN de Acesso',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            const Text('Use um PIN de 4 dígitos para proteger seus dados.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 16),
              decoration: const InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePin,
              child: const Text('Salvar e Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
