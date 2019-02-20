import 'channel.dart';
import 'package:scoped_model/scoped_model.dart';


class ChannelsModel extends Model {
  List<Channel> _recent = [];
  List<Channel>  get recent => _recent;

  set recent (List<Channel> items) {
    _recent = items;

    notifyListeners();
  }

  void addRecent(Channel item) {
    _recent.add(item);

    notifyListeners();
  }
}