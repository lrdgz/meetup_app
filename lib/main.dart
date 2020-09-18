import 'package:flutter/material.dart';
import 'package:flutter_meetuper/screens/counter_home_screen.dart';
import 'package:flutter_meetuper/screens/meetup_details_screen.dart';
import 'package:flutter_meetuper/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/screens/post_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = "Meetuper App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      // home: CounterHomeScreen(title: appTitle),
      home: MeetupHomeScreen(),
      // routes: {
      //   MeetupDetailsScreen.route: (context) => MeetupDetailsScreen(),
      // },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailsScreen.route) {
          final MeetupDetailsArguments arguments = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => MeetupDetailsScreen(meetupId: arguments.id),
          );
        }
      },
    );
  }
}
