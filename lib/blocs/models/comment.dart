import 'package:ameen/blocs/models/user_model.dart';

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
