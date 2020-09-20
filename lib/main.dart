import 'package:flutter/material.dart';
import 'package:flutter_meetuper/models/arguments.dart';
import 'package:flutter_meetuper/screens/login_screen.dart';
import 'package:flutter_meetuper/screens/meetup_details_screen.dart';
import 'package:flutter_meetuper/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/screens/register_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = "Meetuper App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      // home: CounterHomeScreen(title: appTitle),
      home: LoginScreen(),
      routes: {
        MeetupHomeScreen.route: (context) => MeetupHomeScreen(),
        // LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        // MeetupDetailsScreen.route: (context) => MeetupDetailsScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailsScreen.route) {
          final MeetupDetailsArguments arguments = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => MeetupDetailsScreen(meetupId: arguments.id),
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
