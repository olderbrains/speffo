import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<CheckUserState>((event, emit) {
      emit(AuthenticationLoading());
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(UnAuthenticated());
      }
    });
    on<SignOutRequested>((event, emit) async {
      emit(AuthenticationLoading());
      await FirebaseAuth.instance.signOut();
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(UnAuthenticated());
      } else {
        emit(UnAuthenticatedEvent());
      }
    });
  }
}
