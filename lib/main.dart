import 'package:flutter/material.dart';
import 'package:flutter_meetuper/screens/counter_home_screen.dart';
import 'package:flutter_meetuper/screens/meetup_details_screen.dart';
import 'package:flutter_meetuper/screens/post_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = "Meetuper App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: CounterHomeScreen(title: appTitle),
      home: PostHomeScreen(),
      routes: {
        MeetupDetailsScreen.route: (context) => MeetupDetailsScreen(),
      },
    );
  }
}
