import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostData {
  final String postId;
  final String postBody;
  final String authorName ;
  final ImageProvider authorPhoto ;
  final DateTime postTime ;

  PostData({
      this.postId,
      this.postBody,
      this.authorName,
      this.authorPhoto,
      this.postTime
  });

  String get postTimeFormatted => DateFormat.yMd().format(postTime);

}
