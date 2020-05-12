import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/user_data.dart';
import 'package:intl/intl.dart';

class PostData {
  String postId;
  String body;
  String authorName ;
  String authorId ;
  String authorPhoto ;
  DateTime postTime ;
  List<CommentModel> comments;

  PostData ({
      this.postId,
      this.body,
      this.authorName,
      this.authorPhoto,
      this.postTime,
      this.authorId,
  });

  String get postTimeFormatted => DateFormat('hh:mm dd-MMM-yyyy ').format(postTime);
//  String get postTimeFormatted => DateFormat.yMd().format(postTime);

  factory PostData.fromJson(Map<String, dynamic> item) {
    return PostData(
      postId: item['_id'],
      body: item['body'],
      authorName: item['authorName'],
      authorId: item['authorId'],
      postTime: DateTime.parse(item['createdAt']),

    );
  }
}
