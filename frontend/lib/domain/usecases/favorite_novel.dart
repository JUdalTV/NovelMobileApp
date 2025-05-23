import '../repositories/user_repository.dart';

class FavoriteNovel {
  final UserRepository repository;
  FavoriteNovel(this.repository);

  Future<void> call(String token, String novelId) async {
    await repository.favoriteNovel(token, novelId);
  }
} 