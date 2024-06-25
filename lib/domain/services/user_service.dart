import 'package:github_users/data/data_sources/users_ds/remote_users_ds.dart';
import 'package:github_users/data/models/users/user_model.dart';

class UserService {
  final RemoteUsersDs _rds;

  UserService(this._rds);

  Future<List<UserModel>?> fetch(final String search, {bool loadMore = false}) async {
    final res = await _rds.searchUsers(search, maxResults: 25, loadMore: loadMore);
    return res;
  }
}
