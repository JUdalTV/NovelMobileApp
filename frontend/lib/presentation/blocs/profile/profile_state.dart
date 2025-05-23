import 'package:equatable/equatable.dart';
import '../../../domain/entities/reading_history.dart';
import '../../../domain/entities/novel.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<ReadingHistory> readingHistory;
  final List<Novel> readNovels;
  final List<Novel> favoriteNovels;

  ProfileLoaded({
    required this.readingHistory,
    required this.readNovels,
    required this.favoriteNovels,
  });

  @override
  List<Object?> get props => [readingHistory, readNovels, favoriteNovels];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class SignOutSuccess extends ProfileState {} 