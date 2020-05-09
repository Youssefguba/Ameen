import 'dart:convert';

import 'package:ameen/blocs/models/api_response.dart';
import 'package:ameen/blocs/models/post_data.dart';
import 'package:ameen/blocs/models/post_details.dart';
import 'package:http/http.dart' as http;

class PostsService{
  static const API = 'https://quiet-tundra-98924.herokuapp.com/';

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
}