import 'package:newsapp/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<void> call({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      fullName: fullName, phone: phone,
      email: email, password: password,
    );
  }
}