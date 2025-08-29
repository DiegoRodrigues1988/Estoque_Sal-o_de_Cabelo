import 'package:flutter/material.dart';
import 'package:estoque_salao_de_cabelo/services/auth_service.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/home_page.dart';

class CreatePinPage extends StatefulWidget {
  const CreatePinPage({super.key});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _questionController =
      TextEditingController(); // Novo controller para a pergunta
  final _answerController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _pinController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _savePinAndSecurity() async {
    if (_formKey.currentState!.validate()) {
      await _authService.savePin(_pinController.text);
      // Salva a pergunta e a resposta digitadas pelo usuário
      await _authService.saveSecurityQuestion(
          _questionController.text, _answerController.text);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_outline, size: 60),
                const SizedBox(height: 24),
                const Text('Crie seu PIN de Acesso',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                const Text('Use um PIN de 4 dígitos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 16),
                  decoration: const InputDecoration(
                      counterText: '', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.length < 4)
                      return 'PIN deve ter 4 dígitos';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text('Recuperação de Acesso',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                const Text(
                    'Crie uma pergunta e resposta para o caso de esquecer o PIN.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),

                // --- CAMPO DE TEXTO PARA A PERGUNTA ---
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Digite sua pergunta secreta',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Crie uma pergunta'
                      : null,
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Digite sua Resposta Secreta',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Digite sua resposta'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _savePinAndSecurity,
                  child: const Text('Salvar e Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
