import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostData {
  final String postId;
  final String postBody;
  final String authorName ;
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
  });

  String get postTimeFormatted => DateFormat.yMd().format(postTime);

}
