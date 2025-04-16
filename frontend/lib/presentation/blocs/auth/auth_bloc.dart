import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/usecases/signin.dart';
import '../../../domain/usecases/signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;

  AuthBloc({
    required this.signIn,
    required this.signUp,
  }) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  void _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await signIn(SignInParams(
      username: event.username,
      password: event.password,
    ));
    
    result.fold(
      (failure) {
        if (failure is InvalidCredentialsFailure) {
          emit(const SignInError('Tên đăng nhập hoặc mật khẩu không đúng'));
        } else {
          emit(const SignInError('Đã xảy ra lỗi, vui lòng thử lại sau'));
        }
      },
      (user) => emit(Authenticated(user)),
    );
  }

  void _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    // Kiểm tra mật khẩu xác nhận
    if (event.password != event.confirmPassword) {
      emit(const SignUpError('Mật khẩu không khớp'));
      return;
    }
    
    emit(AuthLoading());
    
    final result = await signUp(SignUpParams(
      username: event.username,
      password: event.password,
      confirmPassword: event.confirmPassword,
    ));
    
    result.fold(
      (failure) {
        if (failure is UserAlreadyExistsFailure) {
          emit(const SignUpError('Tên đăng nhập đã tồn tại'));
        } else if (failure is WeakPasswordFailure) {
          emit(const SignUpError('Mật khẩu quá yếu'));
        } else {
          emit(const SignUpError('Đã xảy ra lỗi, vui lòng thử lại sau'));
        }
      },
      (user) => emit(SignUpSuccess()),
    );
  }
  void _onSignOut(SignOutEvent event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }
}