import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_state.dart';

class userCubit extends Cubit<IntailState> {
  userCubit() : super(userLogin());
  String? _link;
  String? _email;
  void LoginEmailPwd(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: pwd
      );
      if (userCredential.user != null) {
        debugPrint('user login');
        emit(userLoginSuccess('success'));
      }
    } on FirebaseAuthException catch (e) {
      emit(userLoginFailure('failure'));
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

  void Signup(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email,
          password: pwd
      );
      emit(SignUpSucc());
    } on FirebaseAuthException catch (e) {
      emit(SignUpError());
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


  void Emailchanged(email) {
    if (email.isEmpty) {
      emit(EmailError('pls enter valid email'));
    } else {
      emit(EmailSucc());
    }
  }

  void Pwdchanged(pwd) {
    if (pwd.isEmpty) {
      emit(PwdError('pls enter Valid Pwd'));
    } else {
      emit(PwdSucc());
    }
  }


  Future<String?> signInwithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      emit(googleSignInSuccess());
    } on FirebaseAuthException catch (e) {
      emit(googleSignInFail());
      print(e.message);
      throw e;
    }
  }


  Future<void> signOutFromGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // var user=_auth.currentUser!.providerData;
    // var u=user.elementAt(0).providerId;
    // print('avjo $user');
    // if ( u == 'google.com') {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      var google=GoogleSignIn().currentUser;
      print('welcome $google');
      try {
        print('Goggle Log Out');
        await _googleSignIn.signOut();
        await _auth.signOut();
        emit(googleLogOutSucc());
        // emit(FbLogOutSucc());
      } on FirebaseAuthException catch (e) {
        emit(googleLogOutFail());
        // emit(FbLogOutFail());
      }
    // }else {
    //   try {
    //     print('faceLogout');
    //     await FacebookAuth.instance.logOut();
    //     await _auth.signOut();

    //   } on FirebaseAuthException catch (e) {
    //     emit(FbLogOutFail());
    //   }
    // }
  }


  signOutFromFb() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      print('faceLogout');
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
      emit(FbLogOutSucc());
    } on FirebaseAuthException catch (e) {
      emit(FbLogOutFail());
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider
          .credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).whenComplete(() {
        emit(faceSignInSuccess());
      });
    } on FirebaseAuthException catch (e) {
      emit(faceSignInFail());
    }
  }



  Future signInWithEmailandLink(userEmail,_link)async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var _userEmail=userEmail;
    _email=_userEmail;
    return await _auth.sendSignInLinkToEmail(
        email: _userEmail,
        actionCodeSettings: ActionCodeSettings(
          url: "https://signupfirebase.page.link/",
          handleCodeInApp: true,
          androidPackageName:"com.example.signup_firebase",
          androidMinimumVersion: "1",
        )
    ).then((value){
      print("email sent");
      emit(SignInWithEmailSucc());
    }).catchError(() {
      emit(SignInWithEmailFail());
    }
    );
  }


  void handleLink(Uri link,userEmail) async {
    if (link != null) {
      print(userEmail);
      final UserCredential user = await FirebaseAuth.instance.signInWithEmailLink(
        email:userEmail,
        emailLink:link.toString(),
      );
      if (user != null) {
        print(user.credential);
      }
    } else {
      print("link is null");
    }
  }


  initialiseFirebaseOnlink(_deepLinkBackground) async {

    final PendingDynamicLinkData? data=await FirebaseDynamicLinks.instance.getInitialLink();
    print('data='+data.toString());
    final Uri? deepLink = data?.link;
    print('deepLink='+deepLink.toString());
    if (deepLink != null) {
      _link = deepLink.toString();
      _signInWithEmailAndLink();
    }
    return deepLink.toString();
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = await user.isSignInWithEmailLink(_link!);
    if (validLink) {
      try {
        // await user.signInWithEmailAndLink(email: _email, link: _link);
      } catch (e) {
        print(e);

      }
    }
  }


}

