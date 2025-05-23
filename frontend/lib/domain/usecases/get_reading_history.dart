import '../repositories/user_repository.dart';
import '../entities/reading_history.dart';

class GetReadingHistory {
  final UserRepository repository;
  GetReadingHistory(this.repository);

  Future<List<ReadingHistory>> call(String token) async {
    return await repository.getReadingHistory(token);
  }
} 