import 'package:flutter/material.dart';
import 'package:flutter_meetuper/models/meetup.dart';
import 'package:flutter_meetuper/services/meetup_api_service.dart';
import 'package:flutter_meetuper/widgets/bottom_navigation.dart';

class MeetupDetailsScreen extends StatefulWidget {
  static final String route = '/meetupDetails';
  final String meetupId;
  final MeetupApiService _api = MeetupApiService();

  MeetupDetailsScreen({this.meetupId});

  @override
  _MeetupDetailsScreenState createState() => _MeetupDetailsScreenState();
}

class _MeetupDetailsScreenState extends State<MeetupDetailsScreen> {
  Meetup meetup;
  @override
  void initState() {
    super.initState();
    _fetchMeetup();
  }

  _fetchMeetup() async {
    final meetup = await widget._api.fetchMeetupById(widget.meetupId);
    setState(() => this.meetup = meetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: meetup != null
          ? ListView(
              children: [
                _HeaderSection(meetup),
                _TitleSection(meetup),
                _AditionalInfoSection(meetup),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(meetup.description),
                  ),
                )
              ],
            )
          : Container(width: 0, height: 0),
      appBar: AppBar(
        title: Text('Meetup Data'),
      ),
      bottomNavigationBar: ButtomNavigation(),
    );
  }
}

class _AditionalInfoSection extends StatelessWidget {
  final Meetup meetup;

  _AditionalInfoSection(this.meetup);

  String _capitalize(String word) {
    return (word != null && word.isNotEmpty)
        ? word[0].toUpperCase() + word.substring(1)
        : '';
  }

  Widget _buildColumn(String label, String text, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13.0, fontWeight: FontWeight.w400, color: color)),
        Text(_capitalize(text),
            style: TextStyle(
                fontSize: 25.0, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildColumn('CATEGORY', meetup.category.name, color),
        _buildColumn('FROM', meetup.timeFrom, color),
        _buildColumn('TO', meetup.timeTo, color),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  final Meetup meetup;

  _TitleSection(this.meetup);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meetup.title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(meetup.shortInfo,
                    style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          Icon(Icons.people, color: color),
          Text('${meetup.joinedPeopleCount} People'),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final Meetup meetup;

  _HeaderSection(this.meetup);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Image.network(
          meetup.image,
          width: width,
          height: 240.0,
          fit: BoxFit.cover,
        ),
        Container(
          width: width,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Feapp.org%2Fwp-content%2Fuploads%2F2019%2F07%2Fplaceholder-avatar.jpg&f=1&nofb=1"),
              ),
              title: Text(
                meetup.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                meetup.shortInfo,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
