import 'package:newsapp/features/auth/domain/repositories/auth_repository.dart';
//give details of user to repository using call function to create new account
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