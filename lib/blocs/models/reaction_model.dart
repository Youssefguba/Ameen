/*
* Reaction Model contain Arrays of Reaction [AmeenReaction, RecommendReaction, ForbiddenReaction]
*
* Model of Reactions
*
*
*   ameen:       [{ameenId,       username: String, profilePic: String}],
*   recommended: [{recommendedId, username: String, profilePic: String}],
*   forbidden:   [{forbiddenId,   username: String, profilePic: String}]
*
*
* */

class AmeenReaction {
  String ameenId;
  String username;
  String userId;
  String postId;
  String profile_pic;

  AmeenReaction({
    this.ameenId,
    this.userId,
    this.postId,
    this.username,
  });

  factory AmeenReaction.fromJson(Map<String, dynamic> item) {
    return AmeenReaction(
      ameenId: item['_id'],
      username: item['username'],
      userId: item['userId'],
      postId: item['postId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': "Youssef",
    };
  }
}

class RecommendReaction {
  String userName;
  String profile_pic;

  RecommendReaction({
    this.userName,
    this.profile_pic,
  });

  factory RecommendReaction.fromJson(Map<String, dynamic> item) {
    return RecommendReaction(
      userName: item['username'],
      profile_pic: item['profilePic'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': userName,
    };
  }
}

class ForbiddenReaction {
  String userName;
  String profile_pic;

  ForbiddenReaction({
    this.userName,
    this.profile_pic,
  });

  factory ForbiddenReaction.fromJson(Map<String, dynamic> item) {
    return ForbiddenReaction(
      userName: item['username'],
      profile_pic: item['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
    };
  }
}
