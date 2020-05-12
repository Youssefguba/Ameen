import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PostDetails {
  String postId;
  String body;
  String authorName;
  String authorId;
  String authorPhoto;
  DateTime postTime;
  List<CommentModel> comments;

  PostDetails({
    this.postId,
    this.body,
    this.authorName,
    this.authorPhoto,
    this.postTime,
    this.authorId,
    this.comments
  });

//  String get postTimeFormatted => DateFormat('hh:mm dd-MMM-yyyy ', 'ar_EG').format(postTime);
  String get postTimeFormatted => DateFormat.yMd().format(postTime);


  factory PostDetails.fromJson(Map<String, dynamic> item) {
    return PostDetails(
      postId: item['_id'],
      body: item['body'],
      authorName: item['authorName'],
      authorId: item['authorId'],
      postTime: DateTime.parse(item['createdAt']),
      comments:(item['comments'] as List).map((i) => CommentModel.fromJson(i)).toList(),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "createdAt": postTime,
      "authorName": authorName,
      "authorId": authorId,
      "authorPhoto": authorPhoto,
    };
  }
}
