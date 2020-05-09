
class PostInsert {
  final String postId;
  final String postBody;
  final String authorName;
  final String authorId;
  final String authorPhoto;
  final DateTime postTime;

  PostInsert ({
    this.postId,
    this.postBody,
    this.authorName,
    this.authorPhoto,
    this.postTime,
    this.authorId,
      });

  Map<String, dynamic> toJson() {
    return {
      "body": postBody,
    };
  }
}