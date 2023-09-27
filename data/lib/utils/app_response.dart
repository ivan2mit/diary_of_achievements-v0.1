import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/response_model.dart';

class AppResponse extends Response{
  AppResponse.serverError(dynamic error,{String? message}) 
  : super.serverError(body: _getResponseModel(error,message)
  );
  
  static MyResponseModel _getResponseModel(error, String? message) {
    if (error is QueryException){
      return MyResponseModel(
        error: error.toString(),
        message: message??error.message
      );
    }

    if (error is AuthorizationParserException){
      return MyResponseModel(
        error: error.toString(),
        message: message ?? "AuthorizationParserException"
      );
    }

    return MyResponseModel(
      error: error.toString(),
      message: message ?? {"Неизвестная ошибка"}
    );
  }
  AppResponse.ok({dynamic body,String? message}) 
  : super.ok(MyResponseModel(data: body, message: message)
  );

  AppResponse.badRequest({String? message}) 
  : super.badRequest(body: MyResponseModel(message: message??"Ошибка запроса")
  );
}