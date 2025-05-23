import '../repositories/user_repository.dart';

class SignOut {
  final UserRepository repository;
  SignOut(this.repository);

  Future<void> call(String token) async {
    await repository.signOut(token);
  }
} 