import '../repositories/user_repository.dart';

class UnfavoriteNovel {
  final UserRepository repository;
  UnfavoriteNovel(this.repository);

  Future<void> call(String token, String novelId) async {
    await repository.unfavoriteNovel(token, novelId);
  }
} 