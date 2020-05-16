import 'package:ameen/blocs/models/comment.dart';
import 'package:ameen/blocs/models/reaction_model.dart';
import 'package:ameen/ui/widgets/post_widgets/reactions_box.dart';
import 'package:intl/intl.dart';

// Model of Post
// ignore: slash_for_doc_comments
/***
* {
    "_id": {},
    "reactions": {
        "ameen": [],
        "recommended": [],
        "forbidden": []
    },
    "createdAt": { Date.now() },
    *
    "authorId": {  "$oid"  },

    "body": String,
    "authorName": String,
    "comments": [
        {
            "_id": {},
            "comment_body": String,
            "authorId": {},
            "authorName": String,
            "createdAt": { Date.now() }
        }
    ]
}
*
**/

class PostDetails {
  String postId;
  String body;
  String authorName;
  String authorId;
  String authorPhoto;
  DateTime postTime;
  AmeenReaction isAmeen;
  List<CommentModel> comments;
  List<AmeenReaction> ameenReaction;
  List<RecommendReaction> recommendReaction;
  List<ForbiddenReaction> forbiddenReaction;

  PostDetails({
    this.postId,
    this.body,
    this.authorName,
    this.authorPhoto,
    this.postTime,
    this.authorId,
    this.comments,
    this.ameenReaction,
    this.recommendReaction,
    this.forbiddenReaction,
  });

//  String get postTimeFormatted => DateFormat('hh:mm dd-MMM-yyyy ', 'ar_EG').format(postTime);
  String get postTimeFormatted =>
      DateFormat.yMMMd('ar').add_jm().format(postTime);

  factory PostDetails.fromJson(Map<String, dynamic> item) {
    return PostDetails(
      postId: item['_id'],
      body: item['body'],
      authorName: item['authorName'],
      authorId: item['authorId'],
      postTime: DateTime.parse(item['createdAt']),
      comments:(item['comments'] as List).map((i) => CommentModel.fromJson(i)).toList(),
      ameenReaction:     (item['ameenReaction']     as List).map((i) => AmeenReaction.fromJson(i)).toList(),
      recommendReaction: (item['recommendReaction'] as List).map((i) => RecommendReaction.fromJson(i)).toList(),
      forbiddenReaction: (item['forbiddenReaction'] as List).map((i) => ForbiddenReaction.fromJson(i)).toList(),
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
