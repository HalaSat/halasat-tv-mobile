import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

import '../models/account.dart';
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

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return LoginForm();
  }

  @override
  bool get wantKeepAlive => true;
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

  bool _isLoadingImage = false;
  bool _isLoading = false;
  FirebaseUser _user;
  bool _hasAccount = true;
  String _name;
  String _email;
  String _password;
  String _photoUrl = DEFAULT_AVATAR_URL;

  @override
  Widget build(BuildContext context) {
    print(ScopedModel.of<AccountModel>(context).status);
    auth.currentUser().then((user) {
      if (user != null) {
        _user = user;
        ScopedModel.of<AccountModel>(context).status = AccountStatus.signedIn;
      } else {
        ScopedModel.of<AccountModel>(context).status = AccountStatus.signedOut;
      }
    });

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
        child: _isLoadingImage ? CupertinoActivityIndicator() : Container(),
      ),
      onTap: () {
        // Generate a unique id for the image, it may use the same uuid
        // of the user in the future
        // TODO: Use user uuid instead

        String imageName = Uuid().v1();
        setState(() => _isLoadingImage = true);
        _pickAndUploadImage('users_profile_images/$imageName.png')
            .then((url) => setState(() {
                  _photoUrl = url;
                  _isLoadingImage = false;
                }));
      },
    );
    Widget _submitButton = RaisedButton(
      child: !_isLoading
          ? Text(_hasAccount ? 'Sign in' : 'Sign up')
          : const CupertinoActivityIndicator(),
      onPressed: _isLoading ? null : () => _submit(context, _hasAccount),
    );

    return ScopedModelDescendant<AccountModel>(
      builder: (BuildContext context, Widget _, AccountModel account) {
        if (account.status == AccountStatus.signedOut)
          return Form(
            // autovalidate: true,
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Align(
                  child: _hasAccount ? Container() : _selectImageField,
                ),
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
        else
          return ChatPage(user: _user);
      },
    );
  }

  Future<void> _submit(BuildContext context, bool hasAccount) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseUser user;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (hasAccount) {
        try {
          user = await auth.signIn(email: _email, password: _password);

          ScopedModel.of<AccountModel>(context).status = AccountStatus.signedIn;
          // Debug
          print('Signed in as $user');
        } catch (error) {
          print(error);
          ScopedModel.of<AccountModel>(context).status =
              AccountStatus.signedOut;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        try {
          user = await auth.signUp(
            name: _name,
            email: _email,
            password: _password,
            photoUrl: _photoUrl,
          );
          ScopedModel.of<AccountModel>(context).status = AccountStatus.signedIn;

          // Debug
          print('Signed up as ${user.displayName}');
        } catch (error) {
          print(error);

          ScopedModel.of<AccountModel>(context).status =
              AccountStatus.signedOut;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
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
