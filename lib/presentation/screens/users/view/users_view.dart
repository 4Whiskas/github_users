import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_users/presentation/screens/users/bloc/user_bloc.dart';
import 'package:github_users/presentation/screens/users/bloc/user_event.dart';
import 'package:github_users/presentation/screens/users/bloc/user_state.dart';
import 'package:github_users/presentation/screens/users/enums/filter_enum.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(
        UserLoadingState(
          filter: FilterEnum.ah,
        ),
      ),
      child: const _UserView(),
    );
  }
}

class _UserView extends StatefulWidget {
  const _UserView();

  @override
  State<_UserView> createState() => _UserViewState();
}

class _UserViewState extends State<_UserView> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UserBloc>();
    bloc.add(
      UserSearchEvent(
        search: searchController.text,
        filter: FilterEnum.ah,
      ),
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: BlocBuilder<UserBloc, UserState>(
          bloc: bloc,
          builder: (context, state) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        if (state is UserLoadingState ||
                            state is UserLoadingMoreState) return;
                        bloc.add(
                          UserSearchEvent(
                            search: value,
                            filter: state.filter,
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        hintText: 'Input login...',
                        suffix: CupertinoButton(
                          onPressed: () {
                            if (state is UserLoadingState ||
                                state is UserLoadingMoreState) return;
                            bloc.add(
                              UserSearchEvent(
                                search: searchController.text,
                                filter: state.filter,
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: FilterEnum.values
                          .map(
                            (e) => Expanded(
                              child: CupertinoButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                color:
                                    e == state.filter ? Colors.blue[50] : null,
                                borderRadius: BorderRadius.zero,
                                minSize: 0,
                                onPressed: () {
                                  if (state is UserLoadingState ||
                                      state is UserLoadingMoreState) return;
                                  bloc.add(
                                    UserSearchEvent(
                                      search: searchController.text,
                                      filter: e,
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      e.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (state is UserLoadingState) ...[
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ] else if (state is UserLodedState) ...[
                      Flexible(
                        fit: FlexFit.loose,
                        child: LazyLoadScrollView(
                          onEndOfPage: () => bloc.add(
                            UserLoadMoreEvent(
                              search: searchController.text,
                              oldUser: state.users,
                              filter: state.filter,
                            ),
                          ),
                          scrollOffset: 800,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 8)
                                .copyWith(
                                    bottom:
                                        MediaQuery.of(context).padding.bottom),
                            itemCount: state.users.length,
                            separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: Divider(
                                color: Colors.black12,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              final item = state.users[index];
                              return CupertinoButton(
                                onPressed: () => launchUrlString(
                                  'https://github.com/${item.login}',
                                ),
                                minSize: 0,
                                padding: EdgeInsets.zero,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(90),
                                        child: CachedNetworkImage(
                                          imageUrl: item.avatar ?? '',
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return const Icon(
                                              Icons.person,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.login,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'Followers: ${item.followersCount}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Following: ${item.followingCount}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (state is UserLoadingMoreState) ...[
                  const SizedBox(height: 8),
                  const Positioned(
                    bottom: 32,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
