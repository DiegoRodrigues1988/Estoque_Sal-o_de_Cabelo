import 'package:flutter/material.dart';
import 'package:estoque_salao_de_cabelo/services/auth_service.dart';
import 'package:estoque_salao_de_cabelo/ui/pages/create_pin_page.dart';

class ResetPinPage extends StatefulWidget {
  const ResetPinPage({super.key});

  @override
  State<ResetPinPage> createState() => _ResetPinPageState();
}

class _ResetPinPageState extends State<ResetPinPage> {
  final _answerController = TextEditingController();
  final AuthService _authService = AuthService();

  // --- MUDANÇAS AQUI ---
  bool _isLoading = true; // Nova variável para controlar o carregamento
  String? _securityQuestion;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() async {
    _securityQuestion = await _authService.getSecurityQuestion();
    // Avisa a tela que o carregamento terminou, tendo encontrado a pergunta ou não
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verifyAnswer() async {
    final isCorrect =
        await _authService.checkSecurityAnswer(_answerController.text);
    if (isCorrect) {
      await _authService.clearPinAndSecurity();
      if (mounted) {
        // Leva para criar um novo PIN
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const CreatePinPage()),
          (route) => false,
        );
      }
    } else {
      setState(() => _errorText = 'Resposta incorreta. Tente novamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Acesso')),
      // --- LÓGICA DE EXIBIÇÃO CORRIGIDA ---
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Mostra enquanto carrega
          : _securityQuestion != null
              ? _buildQuestionForm() // Mostra o formulário se a pergunta foi encontrada
              : _buildNoQuestionFound(), // Mostra mensagem de erro se não encontrou
    );
  }

  // Widget para o formulário de pergunta
  Widget _buildQuestionForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_securityQuestion!,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              labelText: 'Sua Resposta Secreta',
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _verifyAnswer,
            child: const Text('Verificar e Redefinir PIN'),
          ),
        ],
      ),
    );
  }

  // Widget para quando a pergunta não é encontrada
  Widget _buildNoQuestionFound() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'Nenhuma pergunta de segurança encontrada para este perfil. Não é possível recuperar o PIN.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
