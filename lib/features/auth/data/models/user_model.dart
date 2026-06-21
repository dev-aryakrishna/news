import 'package:newsapp/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName, 
    });
  factory UserModel.fromSupabaseUser(String id, String email, Map<String, dynamic>? metadata) {
  return UserModel(
    id: id,
    email: email,
    fullName: metadata?['full_name'] ?? email,
    );
  }
}
