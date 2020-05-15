import 'dart:convert';

import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/insert_post.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:ameen/blocs/models/reaction_model.dart';
import 'package:http/http.dart' as http;

class PostsService {
  static const API = 'https://quiet-tundra-98924.herokuapp.com/';
  static const headers = {'Content-Type': 'application/json'};

  String errorMessage = "يوجد مشكلة ما في الاتصال بالانترنت";

  /// Get List of posts to NewsFeed from the main API
  Future<APIResponse<List<PostData>>> getPostsList() async {
    return await http.get(API).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final posts = <PostData>[];
        for (var item in jsonData) {
          posts.add(PostData.fromJson(item));
        }
        return APIResponse<List<PostData>>(data: posts);
      }
      return APIResponse<List<PostData>>(
          error: true, errorMessage: errorMessage);
    }).catchError((_) =>
        APIResponse<List<PostData>>(error: true, errorMessage: errorMessage));
  }

  /// Call when Clicked on Post to enter the Post Page to get more details of post..
  Future<APIResponse<PostDetails>> getPostsDetails(String postId) async {
    return await http.get(API + postId).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        var post = PostDetails.fromJson(jsonData);
        return APIResponse<PostDetails>(data: post);
      }
      return APIResponse<PostDetails>(error: true, errorMessage: errorMessage);
    }).catchError((_) =>
        APIResponse<PostDetails>(error: true, errorMessage: errorMessage));
  }

  // Called When User create a Post to put it on the user profile and Newsfeed..
  //TODO => You should put the userId variable insted of Hardcode..
  Future<APIResponse<bool>> createPost(PostInsert post) async {
    return await http
        .post(API + 'users/5eb0c28fe1be6b44a094cbf7/',
            headers: headers, body: json.encode(post.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: errorMessage);
    }).catchError(
            (_) => APIResponse<bool>(error: true, errorMessage: errorMessage));
  }

/// Ameen React..
  Future<APIResponse<bool>> ameenReact(String postId, AmeenReaction ameenReact) async {
    return await http.post(API + 'users/5eb0c28fe1be6b44a094cbf7/' + postId + '/reactions', headers: headers,
        body: json.encode(ameenReact.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: errorMessage);
    }).catchError(
            (_) => APIResponse<bool>(error: true, errorMessage: errorMessage));
  }

  /// Remove Ameen React..
  Future<APIResponse<bool>> removeAmeenReact(String postId, String reactionId) async {
    return await http.delete(API + 'users/5eb0c28fe1be6b44a094cbf7/' + postId + '/reactions/' + reactionId , headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: errorMessage);
    }).catchError(
            (_) => APIResponse<bool>(error: true, errorMessage: errorMessage));
  }

  // Called When User create a Post to put it on the user profile and Newsfeed..
  //TODO => You should put the userId variable insted of Hardcode..
  Future<APIResponse<bool>> addComment(CommentModel commentModel, String postId) async {
    return await http.post(API + 'users/5eb0c28fe1be6b44a094cbf7/' + postId + '/comments', headers: headers, body: json.encode(commentModel.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: errorMessage);
    }).catchError(
            (_) => APIResponse<bool>(error: true, errorMessage: errorMessage));
  }
}
