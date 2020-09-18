import 'package:flutter/material.dart';
import 'package:flutter_meetuper/models/meetup.dart';
import 'package:flutter_meetuper/screens/meetup_details_screen.dart';
import 'package:flutter_meetuper/services/meetup_api_service.dart';

class MeetupDetailsArguments {
  final String id;

  MeetupDetailsArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  final MeetupApiService _api = MeetupApiService();

  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];

  @override
  void initState() {
    super.initState();
    _fetchMeetups();
  }

  _fetchMeetups() async {
    final meetups = await widget._api.fetchMeetups();
    setState(() => this.meetups = meetups);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Home"),
        ),
      ),
      body: Column(
        children: [
          _MeetupTitle(),
          _MeetupList(meetups: meetups),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Text("Featured Meetup",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  Meetup meetup;

  _MeetupCard({@required this.meetup});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(meetup.image),
            ),
            title: Text(meetup.title),
            subtitle: Text(meetup.description),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MeetupDetailsScreen.route,
                        arguments: MeetupDetailsArguments(id: meetup.id));
                  },
                  child: Text("Visit Meetup"),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("Favorite Meetup"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MeetupList extends StatelessWidget {
  List<Meetup> meetups;

  _MeetupList({@required this.meetups});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: meetups.length * 2,
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;

          return _MeetupCard(meetup: meetups[index]);
        },
      ),
    );
  }
}
