import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _pinKey = 'user_pin';
  final _questionKey = 'security_question';
  final _answerKey = 'security_answer';

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<bool> checkPin(String pin) async {
    final savedPin = await _storage.read(key: _pinKey);
    return savedPin == pin;
  }

  // --- NOVAS FUNÇÕES ---
  Future<void> saveSecurityQuestion(String question, String answer) async {
    await _storage.write(key: _questionKey, value: question);
    await _storage.write(
        key: _answerKey, value: answer.toLowerCase()); // Salva em minúsculas
  }

  Future<String?> getSecurityQuestion() async {
    return await _storage.read(key: _questionKey);
  }

  Future<bool> checkSecurityAnswer(String answer) async {
    final savedAnswer = await _storage.read(key: _answerKey);
    return savedAnswer == answer.toLowerCase(); // Compara em minúsculas
  }

  Future<void> clearPinAndSecurity() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _questionKey);
    await _storage.delete(key: _answerKey);
  }
}
