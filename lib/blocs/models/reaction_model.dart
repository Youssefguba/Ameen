
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
  String userName;
  String profile_pic;

  AmeenReaction({
    this.userName,
    this.profile_pic,
  });

  factory AmeenReaction.fromJson(Map<String, dynamic> item) {
    return AmeenReaction(
        userName: item['username'],
        profile_pic: item['profilePic'],
    );
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
}


