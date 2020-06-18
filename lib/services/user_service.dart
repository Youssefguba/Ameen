import 'dart:convert';

import 'package:ameen/blocs/global/global.dart';
import 'package:ameencommon/models/api_response.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:http/http.dart' as http;

class UserService {
  String errorMessage = "يوجد مشكلة ما في الاتصال بالانترنت";

  Future<APIResponse<UserModel>> getUserProfile() async {
    return await http.get(Api.API + 'users/' + GlobalVariable.currentUserId).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        var user = UserModel.fromJson(jsonData);
        return APIResponse<UserModel>(data: user);
      }
      return APIResponse<UserModel>(error: true, errorMessage: errorMessage);
    }).catchError((_) =>
        APIResponse<UserModel>(error: true, errorMessage: errorMessage));

  }
}