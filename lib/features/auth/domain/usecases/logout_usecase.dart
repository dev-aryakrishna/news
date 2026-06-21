import 'package:newsapp/features/auth/domain/repositories/auth_repository.dart';
//when user logout this function get called
class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}