import 'dart:developer';

import 'package:injectable/injectable.dart';

@lazySingleton
class AuthDataSource {
  Future<void> login(String username, String password) async {
    if (username == "Lely" && password == "LelyControl2") {
      log('200');
    } else {
      throw Exception("Invalid username or password");
    }
  }
}
