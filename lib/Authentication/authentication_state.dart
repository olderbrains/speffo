part of 'authentication_bloc.dart';

sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class UnAuthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated({required this.user});
}
class UnAuthenticatedEvent extends AuthenticationState {

}
