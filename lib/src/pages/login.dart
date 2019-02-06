import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import '../helpers/auth.dart';
import './chat.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'chat-screen';
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
          child: Text('Go to chat'),
          onPressed: () async => await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ChatPage(
                  user: null,
                );
              }))),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final auth = Auth();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _hasAccount = true;
  String _name;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    Widget _nameField = TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      onSaved: (value) => _name = value,
      validator: _nameValidator,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Name',
          icon: Icon(Icons.person_outline)),
    );
    Widget _emailField = TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => _email = value,
      validator: _emailValidator,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Email',
          icon: Icon(Icons.alternate_email)),
    );
    Widget _passwordField = TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      obscureText: true,
      onSaved: (value) => _password = value,
      validator: _passwordValidator,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Password',
          icon: Icon(Icons.lock_outline)),
    );
    Widget _submitButton = RaisedButton(
      child: _isLoading
          ? CupertinoActivityIndicator()
          : Text(_hasAccount ? 'Sign in' : 'Sign up'),
      onPressed: _isLoading ? null : () => _submit(_hasAccount),
    );
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _hasAccount ? Container() : _nameField,
          _emailField,
          _passwordField,
          _submitButton,
          FlatButton(
            child: Text(_hasAccount
                ? 'Create a new account'
                : 'Already have an account'),
            onPressed: () {
              setState(() => _hasAccount = !_hasAccount);
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit(hasAccount) async {
    FirebaseUser user;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (hasAccount)
        try {
          user = await auth.signIn(email: _email, password: _password);
          print('Signed in as $user');
          _goToChat(user: user);
        } catch (e) {
          print(e);
        }
      else
        try {
          user = await auth.signUp(
              name: _name, email: _email, password: _password);

          print('Signed up as ${user.displayName}');
          _goToChat(user: user);
        } catch (e) {
          print(e);
        }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToChat({@required FirebaseUser user}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChatPage(user: user)));
  }
}

String _nameValidator(String value) {
  if (value.isEmpty) return 'Name cannot be empty';
  return null;
}

String _emailValidator(String value) {
  if (value.isEmpty) return 'Email is required';
  return null;
}

String _passwordValidator(String value) {
  if (value.isEmpty) return 'Password cannot be empty';
  if (value.length < 6) return 'Password must be more than 6 characters';
  return null;
}
