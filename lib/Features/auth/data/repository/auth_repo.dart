import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_tasky/Features/auth/data/inputs/login_inputs.dart';
import 'package:todo_tasky/Features/auth/data/inputs/register_inputs.dart';
import 'package:todo_tasky/Features/auth/data/models/user_model.dart';
import 'package:todo_tasky/core/api/api.dart';
import 'package:todo_tasky/core/constants/app_urls.dart';
import 'package:todo_tasky/core/error_handler/failure.dart';

class AuthRepo {
  final API api;
  AuthRepo(this.api);

  Future<Either<Failure, UserModel>> signIn(LoginInput loginInput) async {
    try {
      final response = await api.post(
        AppUrl.signin,
        data: loginInput.toJson(),
      );

      return right(UserModel.fromJson(response.data));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(
        ServerFailure(e.toString()),
      );
    }
  }

  Future<Either<Failure, UserModel>> signUp(
      RegisterInputs registerInputs) async {
    try {
      final response = await api.post(
        AppUrl.signup,
        data: registerInputs.toJson(),
      );

      return right(UserModel.fromJson(response.data));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(
        ServerFailure(e.toString()),
      );
    }
  }

  Future<Either<Failure, UserModel>> logOut(String token) async {
    try {
      final response = await api.post(
        AppUrl.logout,
        data: {
          'token': token,
        },
      );
      return right(UserModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(
        ServerFailure(e.toString()),
      );
    }
  }
}
