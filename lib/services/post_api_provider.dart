import 'package:flutter_meetuper/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostApiProvider {
  static final PostApiProvider _singleton = PostApiProvider._internal();

  factory PostApiProvider() => _singleton;

  PostApiProvider._internal();

  Future<List<Post>> fetchPosts() async {
    final res = await http.get('https://jsonplaceholder.typicode.com/posts');
    final List<dynamic> parseJson = json.decode(res.body);

    // return parseJson.map((parsePost) {
    //   return Post.fromJSON(parsePost);
    // }).toList();

    return parseJson
        .map((parsePost) => Post.fromJSON(parsePost))
        .take(2)
        .toList();
  }
}
