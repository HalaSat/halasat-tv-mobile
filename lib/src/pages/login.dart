import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart' show DEFAULT_AVATAR_URL;
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
      resizeToAvoidBottomPadding: false,
      body: LoginForm(),
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

  // SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  bool _hasAccount = true;
  String _name;
  String _email;
  String _password;
  String _photoUrl = DEFAULT_AVATAR_URL;

  // @override
  // void initState() {
  //   SharedPreferences.getInstance().then((instance) {
  //     _sharedPreferences = instance;
  //     String token = _sharedPreferences.getString('token');
  //     if (token != null) _signIn(token).then((void v) => super.initState());
  //   });

  //   ;
  // }

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
    Widget _selectImageField = GestureDetector(
      child: CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.blue,
        backgroundImage: NetworkImage(_photoUrl),
      ),
      onTap: () {
        // Generate a unique id for the image, it may use the same uuid
        // of the user in the future
        // TODO: Use user uuid instead

        String imageName = Uuid().v1();
        _pickAndUploadImage('users_profile_images/$imageName.png').then(
          (url) => setState(() {
                _photoUrl = url;
              }),
        );
      },
    );
    Widget _submitButton = RaisedButton(
      child: _isLoading
          ? const CupertinoActivityIndicator()
          : Text(_hasAccount ? 'Sign in' : 'Sign up'),
      onPressed: _isLoading ? null : () => _submit(_hasAccount),
    );

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            _hasAccount ? Container() : _selectImageField,
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
      if (hasAccount) {
        try {
          user = await auth.signIn(email: _email, password: _password);
          // Debug
          print('Signed in as $user');
          // String token = await user.getIdToken();
          // await _sharedPreferences.setString('token', token);

          _goToChat(user: user);
        } catch (e) {
          print(e);
        }
      } else {
        try {
          user = await auth.signUp(
            name: _name,
            email: _email,
            password: _password,
            photoUrl: _photoUrl,
          );

          // Debug
          print('Signed up as ${user.displayName}');
          // String token = await user.getIdToken();
          // await _sharedPreferences.setString('token', token);

          _goToChat(user: user);
        } catch (e) {
          print(e);
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Pick an image from gallery and upload to the specified [path]
  /// on firebase storage
  Future<String> _pickAndUploadImage(String path) async {
    // Pick an image
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    // Get a reference to the path
    if (imageFile != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(path);
      // Upload the file to firebase storage
      StorageUploadTask uploadTask = ref.putFile(imageFile);
      // Get a snapshot of the upload task
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      // Return the download url
      return await taskSnapshot.ref.getDownloadURL();
    }
    return _photoUrl;
  }

  // Future<void> _signIn(String token) async {
  //   FirebaseUser user = await auth.signInWithToken(token);
  //   _goToChat(user: user);
  // }

  void _goToChat({@required FirebaseUser user}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChatPage(user: user),
      ),
    );
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
}
