import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_meetuper/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/blocs/auth_bloc/events.dart';
import 'package:flutter_meetuper/blocs/auth_bloc/states.dart';
import 'package:flutter_meetuper/services/auth_api_service.dart';

export 'package:flutter_meetuper/blocs/auth_bloc/events.dart';
export 'package:flutter_meetuper/blocs/auth_bloc/states.dart';

class AuthBloc extends BlocBase {
  final AuthApiService auth;

  final StreamController<AuthenticationState> _authController =
      StreamController<AuthenticationState>.broadcast();
  Stream<AuthenticationState> get authState => _authController.stream;
  StreamSink<AuthenticationState> get _inAuth => _authController.sink;

  AuthBloc({@required this.auth}) : assert(auth != null);

  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      _inAuth.add(state);
    }
  }

  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool isAuth = await auth.isAuthenticaded();

      if (isAuth) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is InitLogging) {
      yield AuthenticationLoading();
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated();
    }
  }

  @override
  void dispose() {
    _authController.close();
  }
}
