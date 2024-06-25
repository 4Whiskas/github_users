import 'dart:convert';
import 'package:github_users/data/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RemoteUsersDs {
  String endCursor = '';
  bool hasNext = true;
  String? token;
  Future<List<UserModel>?> searchUsers(String query,
      {int maxResults = 10, bool loadMore = false}) async {
    if (token == null) {
      final storage = await SharedPreferences.getInstance();
      final res = storage.getString('token');
      token = res;
    }
    if (!hasNext && loadMore) {
      return null;
    }
    const String url = 'https://api.github.com/graphql';
    final searchQuery = '''
    query {
      search(query: "$query", type: USER, first:$maxResults${loadMore ? ', after:"$endCursor"' : ''}) {
        edges {
          node {
            ... on User {
              avatarUrl
              login
              followers {
                totalCount
              }
              following {
                totalCount
              }
            }
          }
        }
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'query': searchQuery}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> edges = data['data']['search']['edges'];
      hasNext = data['data']['search']['pageInfo']['hasNextPage'];
      if (hasNext) {
        endCursor = data['data']['search']['pageInfo']['endCursor'];
      }

      return edges
          .where(
        (element) =>
            (element['node'] as Map<String, dynamic>).containsKey('login'),
      )
          .map((edge) {
        final user = edge['node'];
        final UserModel userModel = UserModel.fromMap(user);
        return userModel;
      }).toList();
    } else {
      // print('Failed to search users, status code: ${response.statusCode}');
      return [];
    }
  }
}
