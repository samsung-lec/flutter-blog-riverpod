import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/dtos/user_request.dart';
import 'package:flutter_blog/data/models/user.dart';
import 'package:flutter_blog/data/repositories/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 1. 창고 관리자
final sessionProvider = Provider<SessionStore>((ref) {
  return SessionStore();
});

// 2. 창고 데이터
class SessionUser {
  User? user;
  String accessToken;
  String refreshToken;
  bool isLogin;

  SessionUser()
      : accessToken = "",
        refreshToken = "",
        isLogin = false;
}

// 3. 창고
class SessionStore extends SessionUser {
  final mContext = navigatorKey.currentContext;

  Future<void> autoLogin() async {
    String? accessToken = await secureStorage.read(key: "accessToken");

    if(accessToken == null){
      Navigator.of(mContext!).pushNamed(Move.loginPage);
    }else{
      ResponseDTO responseDTO = await UserRepository().fetchAutoLogin(accessToken);
      if(responseDTO.success){
        user = responseDTO.response;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        Navigator.popAndPushNamed(mContext!, Move.postListPage);
      }else{
        Navigator.of(mContext!).pushNamed(Move.loginPage);
      }
    }

  }

  // 로그인
  Future<void> login(LoginReqDTO loginReqDTO) async {
    Logger().d("login");

    // 1. Repository 메소드를 호출하여 응답 결과 및 데이터 받음.
    var (responseDTO, accessToken, refreshToken) = await UserRepository().fetchLogin(loginReqDTO);

    if (responseDTO.success) {
      // 2. 토큰을 휴대폰에 저장
      await secureStorage.write(key: "accessToken", value: accessToken);
      await secureStorage.write(key: "refreshToken", value: refreshToken);

      // 3. 로그인 상태 등록
      Logger().d("세션에 들어갔는지 확인 : ${accessToken}");
      Logger().d("세션에 들어갔는지 확인 : ${refreshToken}");
      user = responseDTO.response;
      this.accessToken = accessToken;
      this.refreshToken = refreshToken;

      // 4. 페이지 이동
      Navigator.popAndPushNamed(mContext!, Move.postListPage);
    } else {
      // 실패 시 스낵바
      ScaffoldMessenger.of(mContext!).showSnackBar(SnackBar(content: Text("로그인 실패 : ${responseDTO.errorMessage}")));
    }
  }

  // 회원 가입
  Future<void> join(JoinReqDTO reqDTO) async {
    Logger().d("join");

    // 1. Repository 메소드를 호출하여 응답 결과 및 데이터 받음.
    ResponseDTO responseDTO = await UserRepository().fetchJoin(reqDTO);

    if (responseDTO.success) {
      // 2. 페이지 이동
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      // 실패 시 스낵바
      ScaffoldMessenger.of(mContext!).showSnackBar(SnackBar(content: Text("회원가입 실패")));
    }
  }

  // 로그아웃
  Future<void> logout() async {
    user = null;
    accessToken = "";
    refreshToken = "";
    isLogin = false;
    await secureStorage.delete(key: "accessToken");
    await secureStorage.delete(key: "refreshToken");
    Logger().d("세션 종료 및 디바이스 JWT 삭제");
  }
}
