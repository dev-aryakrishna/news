import 'package:equatable/equatable.dart';
import 'package:newsapp/l10n/app_localizations.dart';


abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignUpRequested extends SignupEvent {
  final String fullName;
  final String phone;
  final String email;
  final String password;
    final AppLocalizations l10n;


  const SignUpRequested({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.l10n,

  });

  @override
  List<Object?> get props => [fullName, phone, email, password];
}