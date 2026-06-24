import 'package:equatable/equatable.dart';
import 'package:newsapp/l10n/app_localizations.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  final AppLocalizations l10n;

  const LoginRequested({
    required this.email,
    required this.password,
    required this.l10n,
  });

  @override
  List<Object?> get props => [email, password];
}