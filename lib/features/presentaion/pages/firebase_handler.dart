import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


class FirebaseHandler {
  Future<dynamic>? _deepLinkBackground;
  FirebaseAuth? _auth;
  String? _link;
  FirebaseHandler(){
    _auth = FirebaseAuth.instance;
    initialiseFirebaseOnlink(_deepLinkBackground);
  }

  Future getDynamiClikData() async{
    //Returns the deep linked data
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    return data?.link;
  }

  Future getDynamiBGData(){
    //Returns the deep linked data
    return _deepLinkBackground ?? Future((){
      return false;
    });
  }

  sendEmail({email,firebaseURL,androidPackageName}){
    FirebaseAuth.instance.sendSignInLinkToEmail
      (
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: "https://signupfirebase.page.link/",
          handleCodeInApp: true,
          androidPackageName:"com.example.signup_firebase",
          androidMinimumVersion: "1",
      )
    );
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
        // /_showDialog(e.toString());
      }
    }
  }

}