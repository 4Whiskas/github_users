class UserModel {
  UserModel({
    required this.avatar,
    required this.login,
    required this.followersCount,
    required this.followingCount,
  });

  final String? avatar;
  final String login;
  final int followersCount;
  final int followingCount;

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        avatar: map.containsKey('avatarUrl') ? map['avatarUrl'] : null,
        login: map['login'],
        followersCount: map['followers']['totalCount'],
        followingCount: map['following']['totalCount'],
      );
}
