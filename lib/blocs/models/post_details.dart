import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:intl/intl.dart';

class PostDetails {
  final String postId;
  final String postBody;
  final String authorName;
  final String authorId;
  final String authorPhoto;
  final DateTime postTime;
  UserModel author;
  Comment comments;

  PostDetails({
    this.postId,
    this.postBody,
    this.authorName,
    this.authorPhoto,
    this.postTime,
    this.authorId,
  });

  String get postTimeFormatted => DateFormat.yMd().format(postTime);

  factory PostDetails.fromJson(Map<String, dynamic> item) {
    return PostDetails(
      postId: item['_id'],
      postBody: item['body'],
      authorName: item['authorName'],
      authorId: item['authorId'],
      postTime: DateTime.parse(item['createdAt']),
    );
  }
}
