import 'package:newsapp/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedInUseCase {
  final AuthRepository repository;
  IsLoggedInUseCase(this.repository);

  bool call() => repository.isLoggedIn;  // return true or false  
}