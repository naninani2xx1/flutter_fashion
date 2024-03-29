import 'dart:convert';
import 'dart:io';
import 'package:flutter_fashion/core/base/api/api.dart';
import 'package:flutter_fashion/core/base/api/endpoint.dart';
import 'package:flutter_fashion/core/base/exception/exception.dart';
import 'package:flutter_fashion/core/base/exception/login_exception.dart';
import 'package:flutter_fashion/core/base/params/register.dart';
import 'package:flutter_fashion/core/models/response_data.dart';

abstract class AuthProvider {
  Future<ResponseData> login(String phone, String password);

  Future<ResponseData> loginGoogle(String fullname, String email);

  Future<ResponseData> register(RegisterParams params);

  Future<ResponseData> loggout();

  Future<ResponseData> forgotPassword(String newPassword, String phone);

  Future<ResponseData> checkPhone(String phone);
}

class AuthProviderImpl extends AuthProvider {
  final ApiService _apiService;

  AuthProviderImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<ResponseData> login(String phone, String password) async {
    final body = {
      "phone": phone,
      "password": password,
    };

    var response = await _apiService.post(ApiEndpoint.login,
        body: body, isRequestHeader: false);

    if (response.statusCode == 201) {
      throw ParamInputException();
    } else {
      if (response.statusCode != 200) {
        throw ServerException();
      }
    }

    return ResponseData.fromJson(
        jsonDecode(await response.stream.bytesToString()));
  }

  @override
  Future<ResponseData> loggout() async {
    var response = await _apiService.post(ApiEndpoint.loggout);

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return ResponseData.fromJson(
        jsonDecode(await response.stream.bytesToString()));
  }

  @override
  Future<ResponseData> register(RegisterParams params) async {
    var response = await _apiService.post(ApiEndpoint.register,
        body: params.toJson(),
        isRequestHeader: false,
        images: [File(params.image.path)]);

    if (response.statusCode != 200) {
      throw ServerException();
    }
    final data = await response.stream.bytesToString();
    return ResponseData.fromJson(jsonDecode(data));
  }

  @override
  Future<ResponseData> loginGoogle(String fullname, String email) async {
    final body = {
      "fullname": fullname,
      "email": email,
    };

    var response = await _apiService.post(ApiEndpoint.loginGoogle,
        body: body, isRequestHeader: false);

    if (response.statusCode != 200) {
      throw ServerException();
    }
    final data = await response.stream.bytesToString();

    return ResponseData.fromJson(jsonDecode(data));
  }

  @override
  Future<ResponseData> checkPhone(String phone) async {
    var response = await _apiService.post(
      ApiEndpoint.checkPhone,
      body: {"phone": phone},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
    final data = await response.stream.bytesToString();

    return ResponseData.fromJson(jsonDecode(data));
  }

  @override
  Future<ResponseData> forgotPassword(String newPassword, String phone) async {
    var response = await _apiService.post(
      ApiEndpoint.forgotPassword,
      isRequestHeader: false,
      body: {
        "phone": phone,
        "new_password": newPassword,
      },
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
    final data = await response.stream.bytesToString();

    return ResponseData.fromJson(jsonDecode(data));
  }
}
