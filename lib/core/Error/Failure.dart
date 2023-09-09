import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required String errMessage}) : super(errMessage: errMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errMessage: 'Connection timeout with Server');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errMessage: 'Send timeout with Server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errMessage: 'Receive timeout with Server');
      case DioExceptionType.badCertificate:
        return ServerFailure(
            errMessage: 'Bad Certificate error, Please try again!');
      case DioExceptionType.badResponse:
        return ServerFailure.fromBadResponse(
            dioException.response!.statusCode!, dioException.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure(errMessage: 'Request to ApiServer was canceled');
      case DioExceptionType.connectionError:
        return ServerFailure(errMessage: 'Connection error, Please try again!');
      case DioExceptionType.unknown:
        return ServerFailure(errMessage: 'Unexpected error, Please try again!');
      default:
        return ServerFailure(errMessage: 'Unexpected error, Please try again!');
    }
  }

  factory ServerFailure.fromBadResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
          errMessage: 'Your request not found, Please try again!');
    } else if (statusCode == 500) {
      return ServerFailure(
          errMessage: 'Internal Server error, Please try later!');
    } else {
      return ServerFailure(
          errMessage: 'Opps there was an error, Please try again!');
    }
  }
}
