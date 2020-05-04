import 'package:ameen/blocs/models/user_data.dart';

class Comment {
  String commentId, commentBody;
  DateTime createdAt;
  UserModel author;

  Comment({
    this.commentId,
    this.commentBody,
    this.createdAt,
    this.author,
  });
}
