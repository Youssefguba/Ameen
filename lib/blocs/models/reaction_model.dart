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
  String profilePic;

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
  String profilePic;

  RecommendReaction({
    this.userName,
    this.profilePic,
  });

  factory RecommendReaction.fromJson(Map<String, dynamic> item) {
    return RecommendReaction(
      userName: item['username'],
      profilePic: item['profilePic'],
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
  String profilePic;

  ForbiddenReaction({
    this.userName,
    this.profilePic,
  });

  factory ForbiddenReaction.fromJson(Map<String, dynamic> item) {
    return ForbiddenReaction(
      userName: item['username'],
      profilePic: item['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
    };
  }
}
