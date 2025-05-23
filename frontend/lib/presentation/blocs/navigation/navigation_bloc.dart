import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationChanged extends NavigationEvent {
  final int index;

  const NavigationChanged({required this.index});

  @override
  List<Object> get props => [index];
}

// States
class NavigationState extends Equatable {
  final int currentIndex;

  const NavigationState({this.currentIndex = 0});

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [currentIndex];
}

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigationChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
} 