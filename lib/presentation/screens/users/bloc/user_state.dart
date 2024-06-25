import 'package:github_users/data/models/users/user_model.dart';
import 'package:github_users/presentation/screens/users/enums/filter_enum.dart';

abstract class UserState {
  final FilterEnum filter;

  UserState({required this.filter});
}

class UserLoadingState extends UserState {
  UserLoadingState({required super.filter});
}

class UserLodedState extends UserState {
  final List<UserModel> users;

  UserLodedState({
    required this.users,
    required super.filter,
  });
}

class UserLoadingMoreState extends UserLodedState {
  UserLoadingMoreState({
    required super.users,
    required super.filter,
  });
}
