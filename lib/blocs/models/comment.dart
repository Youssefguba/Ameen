import 'package:ameen/blocs/models/user_data.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

CommentModel commentFromJson(String str) => CommentModel.fromJson(json.decode(str));
String commentToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  String commentId, commentBody;
  DateTime createdAt;
  String authorName, authorPhoto, authorId;

  CommentModel({
    this.commentId,
    this.commentBody,
    this.createdAt,
    this.authorName,
    this.authorId,
    this.authorPhoto,
  });

  String get postTimeFormatted => DateFormat('hh:mm dd-MMM-yyyy ', 'ar_EG').format(createdAt);

  factory CommentModel.fromJson(Map<String, dynamic> item) {
    return CommentModel(
      commentId: item['_id'],
      commentBody: item['comment_body'],
      authorName: item['authorName'],
      authorId: item['authorId'],
      createdAt: DateTime.parse(item['createdAt']),

    );
  }

  Map<String, dynamic> toJson() => {
    "_id": commentId,
    "comment_body": commentBody,
    "authorName": authorName,
    "createdAt": createdAt,
    "authorId": authorId
  };
}
