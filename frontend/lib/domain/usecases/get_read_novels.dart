import '../repositories/user_repository.dart';
import '../entities/novel.dart';

class GetReadNovels {
  final UserRepository repository;
  GetReadNovels(this.repository);

  Future<List<Novel>> call(String token) async {
    return await repository.getReadNovels(token);
  }
} 