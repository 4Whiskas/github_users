import 'package:bloc/bloc.dart';
import 'package:github_users/data/models/users/user_model.dart';
import 'package:github_users/domain/di/user.dart';
import 'package:github_users/presentation/screens/users/bloc/user_event.dart';
import 'package:github_users/presentation/screens/users/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(super.initialState) {
    on<UserSearchEvent>(_search);
    on<UserLoadMoreEvent>(_loadMore);
  }

  Future<void> _search(UserSearchEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState(filter: event.filter));
    final res = await User().userService.fetch(
          event.search.isEmpty ? '_' : event.search,
        );
    List<UserModel> users = [];
    users.addAll(event.filter.filter((res ?? [])));
    //I didn’t find a way to filter users by the first letter in Git’s GraphQL, so I decided to use a similar solution
    while (users.length < 16) {
      final loadingMoreRes = await User()
          .userService
          .fetch(event.search.isEmpty ? '_' : event.search, loadMore: true);
      if (loadingMoreRes == null) break;
      users.addAll(event.filter.filter(loadingMoreRes));
    }
    emit(UserLodedState(users: users, filter: event.filter));
  }

  Future<void> _loadMore(
      UserLoadMoreEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingMoreState(users: event.oldUser, filter: event.filter));
    final res = await User().userService.fetch(
          event.search.isEmpty ? '_' : event.search,
          loadMore: true,
        );
    List<UserModel> users = [];
    users.addAll(event.filter.filter((res ?? [])));
    //I didn’t find a way to filter users by the first letter in Git’s GraphQL, so I decided to use a similar solution
    while (users.length < 8) {
      final loadingMoreRes = await User()
          .userService
          .fetch(event.search.isEmpty ? '_' : event.search, loadMore: true);
      if (loadingMoreRes == null) break;
      users.addAll(event.filter.filter(loadingMoreRes));
    }
    emit(
      UserLodedState(
        users: [
          ...event.oldUser,
          ...users,
        ],
        filter: event.filter,
      ),
    );
  }
}
