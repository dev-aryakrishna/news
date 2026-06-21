import 'package:newsapp/features/auth/domain/entities/user_entity.dart';
import 'package:newsapp/features/auth/domain/repositories/auth_repository.dart';
//BloC call this file when user want to login & this file forward to repository
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository); //inject repository 

  Future<UserEntity> call({
    required String email, 
    required String password
    }) 
    {
    return repository.login(
        email: email, 
        password: password
    );
  }
}
