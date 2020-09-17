import 'package:flutter/material.dart';
import 'package:flutter_meetuper/widgets/bottom_navigation.dart';

class MeetupDetailsScreen extends StatelessWidget {
  static final String route = '/meetupDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Iam Meetup Details Screen"),
      appBar: AppBar(
        title: Text('Meetup Data'),
      ),
      bottomNavigationBar: ButtomNavigation(),
    );
  }
}
