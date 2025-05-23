import '../repositories/user_repository.dart';
import '../entities/novel.dart';

class GetFavoriteNovels {
  final UserRepository repository;
  GetFavoriteNovels(this.repository);

  Future<List<Novel>> call(String token) async {
    return await repository.getFavoriteNovels(token);
  }
} 