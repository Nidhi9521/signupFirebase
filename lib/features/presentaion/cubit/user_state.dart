import 'package:flutter/cupertino.dart';

abstract class IntailState{}

class userLogin extends IntailState{}

class userLoginFailure extends IntailState{
  final String value;
  userLoginFailure(this.value);
}

class userLoginSuccess extends IntailState{
  final String value;
  userLoginSuccess(this.value);
}

class EmailError extends IntailState{
  String error;
  EmailError(this.error);
}
class PwdError extends IntailState{
  String error;
  PwdError(this.error);
}

class SignUpSucc extends IntailState{}

class SignUpError extends IntailState{}

class EmailSucc extends IntailState{}

class PwdSucc extends IntailState{}

class googleSignInSuccess extends IntailState{}

class googleSignInFail extends IntailState{}

class faceSignInSuccess extends IntailState{}

class faceSignInFail extends IntailState{}

class googleLogOutSucc extends IntailState{}

class googleLogOutFail extends IntailState{}

class FbLogOutSucc extends IntailState{}

class FbLogOutFail extends IntailState{}

class SignInWithEmailSucc extends IntailState{}

class SignInWithEmailFail extends IntailState{}