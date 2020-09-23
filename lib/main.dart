import 'package:flutter/material.dart';
import 'package:flutter_meetuper/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_meetuper/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/models/arguments.dart';
import 'package:flutter_meetuper/screens/loading_screen.dart';
import 'package:flutter_meetuper/screens/login_screen.dart';
import 'package:flutter_meetuper/screens/meetup_details_screen.dart';
import 'package:flutter_meetuper/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/screens/register_screen.dart';
import 'package:flutter_meetuper/screens/splash_screen.dart';
import 'package:flutter_meetuper/services/auth_api_service.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: AuthBloc(auth: AuthApiService()),
      child: MeetuperApp(),
    );
  }
}

class MeetuperApp extends StatefulWidget {
  @override
  _MeetuperAppState createState() => _MeetuperAppState();
}

class _MeetuperAppState extends State<MeetuperApp> {
  final String appTitle = "Meetuper App";
  AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: StreamBuilder<AuthenticationState>(
        stream: authBloc.authState,
        initialData: AuthenticationUninitialized(),
        builder: (BuildContext context,
            AsyncSnapshot<AuthenticationState> snapshot) {
          final state = snapshot.data;

          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }

          if (state is AuthenticationAuthenticated) {
            return BlocProvider<MeetupBloc>(
              bloc: MeetupBloc(),
              child: MeetupHomeScreen(),
            );
          }

          if (state is AuthenticationUnauthenticated) {
            return LoginScreen();
          }

          if (state is AuthenticationLoading) {
            return LoadingScreen();
          }
        },
      ),
      routes: {
        MeetupHomeScreen.route: (context) => BlocProvider<MeetupBloc>(
              bloc: MeetupBloc(),
              child: MeetupHomeScreen(),
            ),
        RegisterScreen.route: (context) => RegisterScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailsScreen.route) {
          final MeetupDetailsArguments arguments = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => BlocProvider<MeetupBloc>(
              bloc: MeetupBloc(),
              child: MeetupDetailsScreen(meetupId: arguments.id),
            ),
          );
        }

        if (settings.name == LoginScreen.route) {
          final LoginScreenArguments arguments = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => LoginScreen(message: arguments?.message),
          );
        }
      },
    );
  }
}
