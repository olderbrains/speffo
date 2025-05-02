part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthenticationEvent {
  final User? user;
  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class SignOutRequested extends AuthenticationEvent {}
