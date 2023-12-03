import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dtos/page_dto.dart';
import 'package:flutter_blog/data/dtos/post_request.dart';
import 'package:flutter_blog/data/dtos/response_dto.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:logger/logger.dart';

class PostRepository {
  static final PostRepository _instance = PostRepository._single(); // (1) _instance

  factory PostRepository() {
    // (2) PostRepository
    return _instance;
  }

  PostRepository._single(); // (3) PostRepository._single()

  // 목적 : 통신 + 파싱
  Future<ResponseDTO> fetchPostList(String accessToken, {int page = 0}) async {
    Logger().d("accessToken : ${accessToken}");
    Response response = await dio.get("/api/post", queryParameters: {"page": page}, options: Options(headers: {"Authorization": "$accessToken"}));
    Logger().d(response.data);

    // 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      // 전달받은 데이터의 값을 mapList라는 변수에 List<dynamic> 타입으로 저장합니다.

      PageDTO pageDTO = PageDTO.fromJson(responseDTO.response);
      responseDTO.response = pageDTO;
    }
    return responseDTO;
  }

  Future<ResponseDTO> fetchPost(String accessToken, int id) async {
    // 통신
    Response response = await dio.get("/api/post/$id", options: Options(headers: {"Authorization": "$accessToken"}));
    Logger().d(response.data);

    // 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      responseDTO.response = Post.fromJson(responseDTO.response);
    }

    return responseDTO;
  }

  Future<ResponseDTO> savePost(String accessToken, PostSaveReqDTO postSaveReqDTO) async {
    // 통신
    Response response = await dio.post("/api/post", options: Options(headers: {"Authorization": "$accessToken"}), data: postSaveReqDTO.toJson());
    Logger().d(response.data);
    // 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      responseDTO.response = Post.fromJson(responseDTO.response);
    }

    return responseDTO;
  }

  Future<ResponseDTO> updatePost(String accessToken, int id, PostUpdateReqDTO postUpdateReqDTO) async {
    // 통신
    Response response = await dio.put(
      "/api/post/$id",
      options: Options(headers: {"Authorization": "$accessToken"}),
      data: postUpdateReqDTO.toJson(),
    );
    Logger().d(response.data);

    // 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    if (responseDTO.success) {
      responseDTO.response = Post.fromJson(responseDTO.response);
    }

    return responseDTO;
  }

  Future<ResponseDTO> fetchDelete(String accessToken, int id) async {
    // 통신
    Response response = await dio.delete("/api/post/$id", options: Options(headers: {"Authorization": "$accessToken"}));
    Logger().d(response.data);
    // 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

    return responseDTO;
  }
}
