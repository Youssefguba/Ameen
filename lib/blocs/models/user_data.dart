import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserModel {
  String userId, username, userEmail, password;
  int followers, following;
  ImageProvider userImage;
  bool isActive;
  bool isAdministrator = false;
  DateTime joined_date;

  UserModel({
      this.userId,
      this.username,
      this.userEmail,
      this.followers,
      this.following,
      this.userImage,
      this.isActive,
      this.password,
      this.joined_date,


  });

  String get postTimeFormatted =>
      DateFormat.yMMMd('ar').add_jm().format(joined_date);

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": userEmail,
      "password": password,
      "joined_date": joined_date,
      "isAdministrator": isAdministrator,
    };
  }

}
