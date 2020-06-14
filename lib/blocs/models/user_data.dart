import 'package:ameen/blocs/models/post_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserModel {
  String uid;
  String username;
  String userEmail;
  String password;
  String lastTimeUserLogin;
  bool isActive;
  bool isAdministrator = false;
  DateTime joinedDate;
  ImageProvider userImage;
  List<PostData> userPosts;
  List<PostData> savedPosts;
  List<Followers> followers;
  List<Following> following;

  UserModel({
    this.uid,
    this.username,
    this.userEmail,
    this.userImage,
    this.userPosts,
    this.savedPosts,
    this.followers,
    this.following,
    this.isActive,
    this.password,
    this.joinedDate,
  });

  String get postTimeFormatted =>
      DateFormat.yMMMd('ar').add_jm().format(joinedDate);

  factory UserModel.fromJson(Map<String, dynamic> item) {
    return UserModel(
      uid: item['_id'],
      username: item['username'],
      userEmail: item['email'],
      followers:(item['followers'] as List).map((i) => Followers.fromJson(i)).toList(),
      following:(item['following'] as List).map((i) => Following.fromJson(i)).toList(),
      userPosts:(item['posts'] as List).map((i) => PostData.fromJson(i)).toList(),
      savedPosts:(item['saved_posts'] as List).map((i) => PostData.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": userEmail,
      "password": password,
      "joined_date": joinedDate,
      "isAdministrator": isAdministrator,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['id'],
      userEmail: doc['email'],
      username: doc['username'],
    );
  }
}

class Followers {
  String memberId;
  String followerName;
  String profilePic;

  Followers({this.memberId, this.followerName, this.profilePic});

  factory Followers.fromJson(Map<String, dynamic> item) {
    return Followers(
        memberId: item['member_id'],
        followerName: item['follower_name'],
    );
  }
}

class Following {
  String memberId;
  String followerName;
  String profilePic;

  Following({this.memberId, this.followerName, this.profilePic});

  factory Following.fromJson(Map<String, dynamic> item) {
    return Following(
      memberId: item['member_id'],
      followerName: item['follower_name'],
    );
  }
}
