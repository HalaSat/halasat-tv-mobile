import 'package:scoped_model/scoped_model.dart';

enum AccountStatus {
  signing,
  signedIn,
  signedOut,
}

class AccountModel extends Model {
  AccountStatus _status = AccountStatus.signing;
  get status => _status;
  set status(AccountStatus s) {
    print(s);
    _status = s;
    notifyListeners();
  }
}
