class AuthDataSource {
  Future<void> login(String username, String password) async {
    if (username == "Lely" && password == "LelyControl2") {
      
    }
    throw Exception("Invalid username or password");
  }
}