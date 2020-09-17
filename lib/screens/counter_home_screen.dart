import 'package:flutter/material.dart';
import 'package:flutter_meetuper/widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;
  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  int _counter = 0;

  _increment() {
    setState(() {
      _counter++;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget._title),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome in ${widget._title}, lets increments number',
            style: TextStyle(fontSize: 15.0),
          ),
          Text(
            'Click Counter: $_counter',
            style: TextStyle(fontSize: 30.0),
          ),
          RaisedButton(
            child: Text("Go to Details"),
            onPressed: () => Navigator.pushNamed(context, '/meetupDetails'),
          )
        ],
      ),
      bottomNavigationBar: ButtomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(),
        tooltip: 'Incement',
        child: Icon(Icons.add),
      ),
    );
  }
}
