import 'package:github_users/data/models/users/user_model.dart';

enum FilterEnum {
  ah,
  ip,
  qz;

  String get regex {
    switch (this) {
      case FilterEnum.ah:
        return r'^[0-9]*[a-hA-H]+[\w|\W]*$';
      case FilterEnum.ip:
        return r'^[0-9]*[i-pI-P]+[\w|\W]*$';
      case FilterEnum.qz:
        return r'^[0-9]*[q-zQ-Z]+[\w|\W]*$';
    }
  }

  String get title {
    switch (this) {
      case FilterEnum.ah:
        return 'A-H';
      case FilterEnum.ip:
        return 'I-P';
      case FilterEnum.qz:
        return 'Q-Z';
    }
  }

  List<UserModel> filter(List<UserModel> users) {
    return users
        .where(
          (element) => RegExp(regex).hasMatch(element.login),
        )
        .toList();
  }
}
