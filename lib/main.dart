import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_firebase/features/presentaion/cubit/dashboard_cubit.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_cubit.dart';
import 'package:signup_firebase/features/presentaion/pages/dashboard.dart';
import 'package:signup_firebase/features/presentaion/pages/fb_home.dart';
import 'package:signup_firebase/features/presentaion/pages/google_home.dart';
import 'features/presentaion/pages/login.dart';
import 'features/presentaion/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/screen2': (BuildContext context) =>
            BlocProvider(create: (context) => userCubit(), child: login()),
        '/screen3': (BuildContext context) =>
            BlocProvider(create: (context) => userCubit(), child: signup()),
        '/screen4': (BuildContext context) =>
            BlocProvider(create: (context) => DashCubit(), child: DashBoard()),
        '/screen5': (BuildContext context) =>
            BlocProvider(create: (context) => userCubit(), child: GoogleHome()),
        '/screen6': (BuildContext context) =>
            BlocProvider(create: (context) => userCubit(), child: FaceBookPage()),
        '/screen1': (BuildContext context) => new MyHomePage()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> with WidgetsBindingObserver {

  // final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  late Timer _timerLink;
  late bool newLaunch;
  var finalEmail, _finalEmail;
  User? user = FirebaseAuth.instance.currentUser;
  var emailuser = FirebaseAuth.instance.authStateChanges();
  var google = GoogleSignIn().currentUser;
  var fb = FacebookAuth.instance;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('did change method calling main');
      _retrieveDynamicLink();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    getValidationData().whenComplete(() async {
      Timer(
          const Duration(seconds: 5),
              () =>
              fb == null && google == null ?
                user == null ?
                ((finalEmail == null
                      ? (
                          _finalEmail== null ?
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/screen2', (Route<dynamic> route) => false) :
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/screen5', (Route<dynamic> route) => false)
                        )
                        :
                          (
                          Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/screen4', ModalRoute.withName('/screen1')
                        )
                    )
                  )
                )
                : (
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/screen5', (Route<dynamic> route) => false)
              ) : (Navigator.of(context).pushNamedAndRemoveUntil(
                  '/screen2', (Route<dynamic> route) => false)
              )
      );
    });
  }

  String? _link, _email;

  Future<String?> _retrieveDynamicLink() async {
    try {
      print('retrive main page mehod');
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      if(data != null) {
        print('Data Main=' + data.toString());
        final Uri? deepLink = data.link;
        print('Deep Link MAin=' + deepLink.toString());
        if (deepLink != null) {
          _link = deepLink.toString();
          print('_sign in call time');
          _signInWithEmailAndLink();
        }
        return deepLink.toString();
      }else{
        print('data not found');
      }
    }catch (e){
      print(e);
      print('retrive error');
    }
    return null;
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = await user.isSignInWithEmailLink(_link!);
    if (validLink) {
      try {
        print('main _sign method');
        final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
        _email=sharedPreferences.getString('emailis');
        if(_email!=Null) {
          await user.signInWithEmailLink(email: _email!, emailLink: _link!)
              .then((value) {
              print('Method call success');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/screen5', (Route<dynamic> route) => false);
          });
          // signInWithEmailLink(email: _email!, emailLink: _link!);
        }else{
          print('error');
        }
          // signInWithEmailLink(email: _email!, emailLink: _link!);
      } catch (e) {
        print(e);
      }
    }
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    var obtainedEmail2 = sharedPreferences.getString('emailist');
    setState(() {
      finalEmail = obtainedEmail;
      _finalEmail = obtainedEmail2;
    });
    print(finalEmail);
  }

  loadNewLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool? _newLaunch = prefs.getBool('id');
      newLaunch = _newLaunch!;
    });
    //bool newLaunch =prefs.getBool('id') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _retrieveDynamicLink();
    return FlutterLogo(size: MediaQuery
            .of(context)
            .size
            .height);
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Splash Screen Example")),
      body: const Center(
          child: Text("Welcome to Home Page",
              style: TextStyle(color: Colors.black, fontSize: 30))),
    );
  }
}
