import 'package:equatable/equatable.dart';
import 'novel.dart';

class ReadingHistory extends Equatable {
  final Novel novel;
  final int minutesRead;
  final DateTime lastRead;

  const ReadingHistory({
    required this.novel,
    required this.minutesRead,
    required this.lastRead,
  });

  @override
  List<Object?> get props => [novel, minutesRead, lastRead];
} 