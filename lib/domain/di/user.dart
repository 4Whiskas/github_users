import 'package:github_users/data/data_sources/users_ds/remote_users_ds.dart';
import 'package:github_users/domain/services/user_service.dart';

class User {
  User._() {
    init();
  }

  static User? _instance;
  late final UserService _userService;
  UserService get userService => _userService;

  factory User() => _instance ??= User._();

  void init() {
    final usersRds = RemoteUsersDs();
    _userService = UserService(usersRds);
  }
}
