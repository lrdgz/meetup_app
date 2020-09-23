import 'package:flutter/material.dart';
import 'package:flutter_meetuper/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_meetuper/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/models/meetup.dart';
import 'package:flutter_meetuper/screens/meetup_details_screen.dart';
import 'package:flutter_meetuper/services/auth_api_service.dart';

class MeetupDetailsArguments {
  final String id;

  MeetupDetailsArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static final String route = '/meetups';

  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];
  AuthBloc _authBloc;

  @override
  void initState() {
    BlocProvider.of<MeetupBloc>(context).fetchMeetups();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    // final meetupBloc = BlocProvider.of<MeetupBloc>(context);
    // meetupBloc.fetchMeetups();
    // meetupBloc.meetups.listen((data) => print(data));
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
          _MeetupTitle(authBloc: _authBloc),
          _MeetupList(),
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
  final AuthApiService auth = AuthApiService();
  final AuthBloc authBloc;

  _MeetupTitle({@required this.authBloc});

  Widget _buildUserWelcome() {
    return FutureBuilder<bool>(
      future: auth.isAuthenticaded(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          final user = auth.authUser;
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                user.avatar != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      )
                    : Container(height: 0, width: 0),
                Text("Welcome ${user.username}"),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    authBloc.dispatch(LoggedOut());
                    // auth.logout().then((isLogout) =>
                    //     Navigator.pushNamedAndRemoveUntil(context, "/login",
                    //         (Route<dynamic> route) => false));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(height: 0, width: 0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Featured Meetups",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildUserWelcome(),
        ],
      ),
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Meetup>>(
        stream: BlocProvider.of<MeetupBloc>(context).meetups,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<Meetup>> snapshot) {
          var meetups = snapshot.data;
          return ListView.builder(
            itemCount: meetups.length * 2,
            itemBuilder: (BuildContext context, int i) {
              if (i.isOdd) {
                return Divider();
              }

              final index = i ~/ 2;

              return _MeetupCard(meetup: meetups[index]);
            },
          );
        },
      ),
    );
  }
}
