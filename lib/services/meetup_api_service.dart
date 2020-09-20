import 'package:flutter_meetuper/models/meetup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class MeetupApiService {
  // final String url = Platform.isIOS
  //     ? 'http://localhost:3002/api/v1'
  //     : 'http://10.0.2.2:3002/api/v1';

  final String url = Platform.isIOS
      ? 'http://192.168.0.4:3002/api/v1'
      : 'http://192.168.0.4:3002/api/v1';

  // final String url = Platform.isIOS
  //     ? 'http://10.0.0.12:3002/api/v1'
  //     : 'http://10.0.0.12:3002/api/v1';

  static final MeetupApiService _singleton = MeetupApiService._internal();

  factory MeetupApiService() => _singleton;

  MeetupApiService._internal();

  Future<List<Meetup>> fetchMeetups() async {
    final res = await http.get('$url/meetups');
    final List parseMeetups = json.decode(res.body);
    return parseMeetups.map((meetup) => Meetup.fromJSON(meetup)).toList();
  }

  Future<Meetup> fetchMeetupById(String id) async {
    final res = await http.get('$url/meetups/$id');
    final parseMeetups = json.decode(res.body);
    return Meetup.fromJSON(parseMeetups);
  }
}
