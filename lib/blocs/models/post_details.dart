import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:intl/intl.dart';

class PostDetails {
  String postId;
  String body;
  String authorName;
  String authorId;
  String authorPhoto;
  DateTime postTime;
  UserModel author;
  Comment comments;

  PostDetails({
    this.postId,
    this.body,
    this.authorName,
    this.authorPhoto,
    this.postTime,
    this.authorId,
  });

  String get postTimeFormatted => DateFormat.yMd().format(postTime);

  factory PostDetails.fromJson(Map<String, dynamic> item) {
    return PostDetails(
      postId: item['_id'],
      body: item['body'],
      authorName: item['authorName'],
      authorId: item['authorId'] ,
      postTime: DateTime.parse(item['createdAt']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "body": body,
      "createdAt": postTime,
      "authorName": authorName,
      "authorId": authorId,
      "authorPhoto": authorPhoto,
    };
  }
}
