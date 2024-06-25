import 'package:github_users/data/models/users/user_model.dart';
import 'package:github_users/presentation/screens/users/enums/filter_enum.dart';

abstract class UserEvent {
  final FilterEnum filter;

  UserEvent({required this.filter});
}

class UserSearchEvent extends UserEvent {
  final String search;

  UserSearchEvent({
    required this.search,
    required super.filter,
  });
}

class UserLoadMoreEvent extends UserEvent {
  final String search;
  final List<UserModel> oldUser;

  UserLoadMoreEvent({
    required this.search,
    required this.oldUser,
    required super.filter,
  });
}
