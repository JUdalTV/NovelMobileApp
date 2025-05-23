import '../repositories/user_repository.dart';

class UpdateReadingTime {
  final UserRepository repository;
  UpdateReadingTime(this.repository);

  Future<void> call(String token, String novelId, int minutes) async {
    await repository.updateReadingTime(token, novelId, minutes);
  }
} 