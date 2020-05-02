import 'package:flutter/material.dart';

class UserModel {
  String userId, username, userEmail;
  int followers, following;
  ImageProvider userImage;
  bool isActive;

  UserModel({
      this.userId,
      this.username,
      this.userEmail,
      this.followers,
      this.following,
      this.userImage,
      this.isActive
  });
}
