import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/dtos/user_request.dart';
import 'package:flutter_blog/data/models/user.dart';
import 'package:logger/logger.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._single();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._single();
  
  Future<ResponseDTO> fetchAutoLogin(String accessToken) async {
    Response response = await dio.post("/auto/login", options: Options(headers: {"Authorization": "$accessToken"}));
    Logger().d(response.data);

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      responseDTO.response = User.fromJson(responseDTO.response);
      return responseDTO;
    }

    return responseDTO;
  }

  Future<(ResponseDTO, String, String)> fetchLogin(LoginReqDTO requestDTO) async {
    Response response = await dio.post("/login", data: requestDTO.toJson());
    Logger().d(response.data);

    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      responseDTO.response = User.fromJson(responseDTO.response);
      final accessToken = response.headers["Authorization"]!.first;
      final refreshToken = response.headers["X-Refresh-Token"]!.first;

      Logger().d("로그인 후 accessToken : ${accessToken}");
      Logger().d("로그인 후 refreshToken : ${refreshToken}");

      return (responseDTO, accessToken, refreshToken);
    } else {
      return (responseDTO, "", "");
    }
  }

  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    Response response = await dio.post("/join", data: requestDTO.toJson());
    Logger().d(response.data);
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      responseDTO.response = User.fromJson(responseDTO.response);
    }
    return responseDTO;
  }
}
