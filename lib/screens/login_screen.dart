import 'package:flutter/material.dart';
import 'package:flutter_meetuper/models/forms.dart';
import 'package:flutter_meetuper/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/screens/register_screen.dart';
import 'package:flutter_meetuper/services/auth_api_service.dart';
import 'package:flutter_meetuper/utils/valitators.dart';

class LoginScreen extends StatefulWidget {
  final String message;
  static String route = '/login';
  final AuthApiService authApi = AuthApiService();

  LoginScreen({this.message});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  LoginFormData _loginData = LoginFormData();
  bool _autoValidate = false;
  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForMessage());
    _checkForMessage();
  }

  void _checkForMessage() {
    // Future.delayed(Duration(), () {});
    if (widget.message != null && widget.message.isNotEmpty) {
      Scaffold.of(_scaffoldContext).showSnackBar(
        SnackBar(
          content: Text(widget.message),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _login() {
    widget.authApi.login(_loginData).then((data) {
      // print(data);
      Navigator.pushReplacementNamed(context, MeetupHomeScreen.route);
    }).catchError((error) {
      Scaffold.of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(error['errors']['message'])));
    });
  }

  _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _login();
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Login Screen"),
        ),
      ),
      body: Builder(
        builder: (context) {
          _scaffoldContext = context;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Login And Explore',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    key: _emailKey,
                    style: Theme.of(context).textTheme.headline6,
                    validator: composeValidators('email', [
                      requiredValidator,
                      minLengthValidator,
                      emailValidator
                    ]),
                    decoration: InputDecoration(hintText: 'Email Adrress'),
                    onSaved: (value) => _loginData.email = value,
                  ),
                  TextFormField(
                    obscureText: true,
                    key: _passwordKey,
                    style: Theme.of(context).textTheme.headline6,
                    validator: composeValidators(
                        'password', [requiredValidator, minLengthValidator]),
                    decoration: InputDecoration(hintText: 'Password'),
                    onSaved: (value) => _loginData.password = value,
                  ),
                  _buildLinks(),
                  Container(
                    alignment: Alignment(-1.0, 0.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: const Text("Submit"),
                      onPressed: _submit,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinks() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, RegisterScreen.route),
            child: Text(
              'Not Registered yet? Register Now',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, MeetupHomeScreen.route),
            child: Text(
              'Continue to Home Page',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
