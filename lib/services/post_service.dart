import 'dart:convert';

import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/insert_post.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:http/http.dart' as http;

class PostsService{
  static const API = 'https://quiet-tundra-98924.herokuapp.com/';
  static const headers = {
    'Content-Type': 'application/json'
  };

  // Get List of posts to NewsFeed from the main API
  Future<APIResponse<List<PostData>>> getPostsList() {
      return http.get(API).then((data) {
          if(data.statusCode == 200 ){
            final jsonData = json.decode(data.body);
            final posts = <PostData>[];
            for(var item in jsonData){
              posts.add(PostData.fromJson(item));
            }
            return APIResponse<List<PostData>>(data: posts);
          }
          return APIResponse<List<PostData>>(error: true, errorMessage: "An error occured");
      }).catchError((_) =>  APIResponse<List<PostData>>(error: true, errorMessage: "An error occured"));
  }

  // Call when Clicked on Post to enter the Post Page to get more details of post..
  Future<APIResponse<PostDetails>> getPostsDetails(String postId) {
    return http.get(API + postId).then((data) {
      if(data.statusCode == 200 ){
        final jsonData = json.decode(data.body);
          var post = PostDetails.fromJson(jsonData);
            return APIResponse<PostDetails>(data: post);
      }
      return APIResponse<PostDetails>(error: true, errorMessage: "An error occured");
    }).catchError((_) =>  APIResponse<PostDetails>(error: true, errorMessage: "An error occured"));
  }

  // Called When User create a Post to put it on the user profile and Newsfeed..
  //TODO => You should put the userId variable insted of Hardcode..
  Future<APIResponse<bool>> createPost(PostInsert post) {
    return http.post(API + 'users/5eb0c28fe1be6b44a094cbf7/', headers: headers, body: json.encode(post.toJson() ) ).then((data) {
      if(data.statusCode == 201 ){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: "An error occured");
    }).catchError((_) =>  APIResponse<bool>(error: true, errorMessage: "An error occured"));
  }
}