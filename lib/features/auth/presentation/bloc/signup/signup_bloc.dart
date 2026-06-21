import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/auth/domain/usecases/signup_usecase.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignUpUseCase signUpUseCase;

  SignupBloc({required this.signUpUseCase}) : super(SignupInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      await signUpUseCase(
        fullName: event.fullName,
        phone: event.phone,
        email: event.email,
        password: event.password,
      );
      emit(const SignupSuccess('Account created successfully!'));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}