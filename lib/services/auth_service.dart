import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _key = 'user_pin'; // Chave para salvar o PIN

  // Verifica se já existe um PIN salvo
  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _key);
    return pin != null;
  }

  // Salva o PIN no armazenamento seguro
  Future<void> savePin(String pin) async {
    await _storage.write(key: _key, value: pin);
  }

  // Verifica se o PIN digitado está correto
  Future<bool> checkPin(String pin) async {
    final savedPin = await _storage.read(key: _key);
    return savedPin == pin;
  }
}
