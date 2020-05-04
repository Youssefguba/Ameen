import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostData {
  final String postId;
  final String postBody;
  final String authorName ;
  final String authorId ;
  final ImageProvider authorPhoto ;
  final DateTime postTime ;
  final UserModel author;
  final Comment comment;

  PostData({
      this.postId,
      this.postBody,
      this.authorName,
      this.authorPhoto,
      this.postTime,
      this.author,
      this.comment,
      this.authorId,
  });

  String get postTimeFormatted => DateFormat.yMd().format(postTime);

  factory PostData.fromJson(Map<String, dynamic> item) {
    return PostData(
      postId: item['_id'],
      postBody: item['body'],
      authorName: item['authorName'],
      authorId: item['authorId'],
      postTime: DateTime.parse(item['createdAt']),
    );
  }
}
