part of 'authentication_bloc.dart';

sealed class AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class Authenticated extends AuthenticationState {
 final User user;

  Authenticated({required this.user});
}

final class UnAuthenticated extends AuthenticationState {
  final String message;

  UnAuthenticated({required this.message});
}
