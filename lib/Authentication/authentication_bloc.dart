import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _authSubscription;

  AuthenticationBloc({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance,
      super(AuthenticationLoading()) {
    _authSubscription = _auth.authStateChanges().listen((user) {
      add(CheckAuthenticationEvent());
    });

    on<CheckAuthenticationEvent>((event, emit) async {
      try {
        emit(AuthenticationLoading());
        final user = _auth.currentUser;

        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(
            UnAuthenticated(message: 'No User Found'),
          );
        }
      } catch (e) {
        emit(UnAuthenticated(message: 'Failed to check authentication status'));
      }
    });

    on<SignOutUser>((event, emit) async {
      try {
        emit(AuthenticationLoading());
        await _auth.signOut();
        emit(UnAuthenticated(message: "SignOut Successfully"));
      } catch (e) {
        emit(UnAuthenticated(message: 'Failed to sign out'));
        // Optionally re-emit the current state
        add(CheckAuthenticationEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
