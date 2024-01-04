import 'dart:io';

class UnAuthorizedException extends HttpException{
  UnAuthorizedException(super.message);//401 keganda refresh token qib berepti
}