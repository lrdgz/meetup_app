import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetuper/models/arguments.dart';
import 'package:flutter_meetuper/models/forms.dart';
import 'package:flutter_meetuper/services/auth_api_service.dart';
import 'package:flutter_meetuper/utils/valitators.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  final AuthApiService auth = AuthApiService();

  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  BuildContext _scaffoldContext;

  RegisterFormData _registerFormData = RegisterFormData();

  void _handleSuccess(data) {
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false,
        arguments:
            LoginScreenArguments('You have beeen successfylly registered.'));
  }

  void _handleError(error) {
    Scaffold.of(_scaffoldContext)
        .showSnackBar(SnackBar(content: Text(error['errors']['message'])));
    // Scaffold.of(_scaffoldContext)
    //     .showSnackBar(SnackBar(content: Text(error['errors']['message'])));
  }

  void _register() {
    widget.auth
        .register(_registerFormData)
        .then(_handleSuccess)
        .catchError(_handleError);
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _register();
      print(_registerFormData.toJSON());
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: Builder(builder: (context) {
          _scaffoldContext = context;
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: ListView(
                  children: [
                    _buildTitle(),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                      validator: composeValidators('name', [requiredValidator]),
                      onSaved: (value) => _registerFormData.name = value,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        hintText: 'Username',
                      ),
                      validator:
                          composeValidators('username', [requiredValidator]),
                      onSaved: (value) => _registerFormData.username = value,
                    ),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                        ),
                        validator: composeValidators(
                            'Email Address', [requiredValidator]),
                        onSaved: (value) => _registerFormData.email = value,
                        keyboardType: TextInputType.emailAddress),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: 'Avatar Url',
                        ),
                        onSaved: (value) => _registerFormData.avatar = value,
                        keyboardType: TextInputType.url),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: composeValidators(
                          'password', [requiredValidator, minLengthValidator]),
                      onSaved: (value) => _registerFormData.password = value,
                      obscureText: true,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline6,
                      decoration: InputDecoration(
                        hintText: 'Password Confirmation',
                      ),
                      validator: composeValidators('password confirmation',
                          [requiredValidator, minLengthValidator]),
                      onSaved: (value) =>
                          _registerFormData.passwordConfirmation = value,
                      obscureText: true,
                    ),
                    _buildLinksSection(),
                    _buildSubmitBtn()
                  ],
                ),
              ));
        }));
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      alignment: Alignment(-1.0, 0.0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: const Text('Submit'),
        onPressed: _submit,
      ),
    );
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
            child: Text(
              'Already Registered? Login Now.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/meetups");
              },
              child: Text(
                'Continue to Home Page',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ))
        ],
      ),
    );
  }
}
