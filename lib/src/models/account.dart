import 'package:scoped_model/scoped_model.dart';

enum AccountStatus {
  signedIn,
  signedOut,
}

class AccountModel extends Model {
  AccountStatus _status = AccountStatus.signedOut;
  get status => _status;
  set status(AccountStatus s) {
    print(s);
    _status = s;
    notifyListeners();
  }
}
