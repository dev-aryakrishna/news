import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:newsapp/core/utils/auth_error_localizer.dart';
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
      emit( SignupSuccess(event.l10n.signupSuccess));
    } catch (e) {
      if(e is AuthException){
       if (e.toString().contains('Failed to fetch') ||
            e.toString().contains('ClientException')) {
              emit(SignupFailure(event.l10n.errorNetworkError));
          }
          else{
            final message = AuthErrorLocalizer.localize(event.l10n, e.code?? '');
            emit(SignupFailure(message));
          }
      }
    }
  }
}