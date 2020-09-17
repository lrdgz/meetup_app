import 'package:flutter/material.dart';
import 'package:flutter_meetuper/models/post.dart';
import 'package:flutter_meetuper/services/post_api_provider.dart';
import 'package:flutter_meetuper/widgets/bottom_navigation.dart';
import 'package:faker/faker.dart';

class PostHomeScreen extends StatefulWidget {
  final PostApiProvider _api = PostApiProvider();
  @override
  _PostHomeScreenState createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  _fetchPosts() async {
    List<Post> posts = await widget._api.fetchPosts();
    setState(() => _posts = posts);
  }

  _addPost() {
    final id = faker.randomGenerator.integer(999999);
    final title = faker.food.dish();
    final body = faker.food.cuisine();
    final newPost = Post(title: title, body: body, id: id);
    setState(() => _posts.add(newPost));
  }

  Widget build(BuildContext context) {
    return _PostList(
      posts: _posts,
      createPost: _addPost,
    );
  }
}

class _PostList extends StatelessWidget {
  final List<Post> _posts;
  final Function createPost;

  _PostList({@required List<Post> posts, @required this.createPost})
      : _posts = posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Posts"),
        ),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;

          return ListTile(
            title: Text(_posts[index].title),
            subtitle: Text(_posts[index].body),
          );
        },
      ),
      bottomNavigationBar: ButtomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: createPost,
        tooltip: 'Add post',
        child: Icon(Icons.add),
      ),
    );
  }
}

// title: Text(_posts[index]["title"]),
//   subtitle: Text(_posts[index]["body"]),
