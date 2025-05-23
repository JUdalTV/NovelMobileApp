import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../domain/usecases/get_reading_history.dart';
import '../../../domain/usecases/get_read_novels.dart';
import '../../../domain/usecases/get_favorite_novels.dart';
import '../../../domain/usecases/signout.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetReadingHistory getReadingHistory;
  final GetReadNovels getReadNovels;
  final GetFavoriteNovels getFavoriteNovels;
  final SignOut signOut;

  ProfileBloc({
    required this.getReadingHistory,
    required this.getReadNovels,
    required this.getFavoriteNovels,
    required this.signOut,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final readingHistory = await getReadingHistory(event.token);
      final readNovels = await getReadNovels(event.token);
      final favoriteNovels = await getFavoriteNovels(event.token);
      emit(ProfileLoaded(
        readingHistory: readingHistory,
        readNovels: readNovels,
        favoriteNovels: favoriteNovels,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<ProfileState> emit) async {
    try {
      await signOut(event.token);
      emit(SignOutSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
} 