part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {}

final class CheckAuthenticationEvent extends AuthenticationEvent {}

final class SignOutUser extends AuthenticationEvent {}
