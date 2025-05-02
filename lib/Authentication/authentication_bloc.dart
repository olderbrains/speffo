import 'dart:async';

import 'package:equatable/equatable.dart';
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
      add(AuthUserChanged(user));
    });

    on<AuthUserChanged>((event, emit) {
      if (event.user != null) {
        emit(Authenticated(user: event.user!));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthenticationLoading());
      await _auth.signOut();
      // Auth state change will trigger automatically
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
