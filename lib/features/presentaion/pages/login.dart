import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login>  with WidgetsBindingObserver{

  final formGlobalKey = GlobalKey<FormState>();
  String? _email,_link;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }




  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(
                top: 100.0, right: 20.0, left: 20.0, bottom: 20.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formGlobalKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (email) {
                      if (!isEmailValid(email.toString()) || email == Null)
                        return 'Entera valid email address';
                      else
                        return null;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Enter Email',
                        hintText: 'Enter Email'),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (password) {
                      if (isPasswordValid(password.toString()))
                        return null;
                      else
                        return 'Enter a valid password';
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.remove_red_eye),
                        labelText: 'Enter Password',
                        hintText: 'Enter Password'),
                  ),
                  Container(
                    margin: const EdgeInsets.all(25),
                    child: BlocListener<userCubit, IntailState>(
                      listener: (context, state) async {
                        if (state is userLoginSuccess) {
                          showToast('success');
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('email', emailController.text);
                          //Navigator.popAndPushNamed(context, '/screen4');
                          //Navigator.of(context).pushNamedAndRemoveUntil('/screen4', ModalRoute.withName('/screen2'));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/screen4', (Route<dynamic> route) => false);
                        }
                        if (state is userLoginFailure) {
                          showToast('Failure');
                          emailController.clear();
                          passwordController.clear();
                        }
                      },
                      child: FlatButton(
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            formGlobalKey.currentState?.save();
                            context.read<userCubit>().LoginEmailPwd(
                                emailController.text, passwordController.text);
                          }
                        },
                        color: Colors.blueAccent,
                        child: const Text(
                          'LogIn',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                  BlocListener<userCubit, IntailState>(
                      listener: (context, state) {
                        if (state is googleSignInSuccess) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/screen5', (Route<dynamic> route) => false);
                          showToast('Successs');
                        }
                        if (state is googleSignInFail) {
                          showToast('Failure');
                        }
                      },
                      child: FlatButton(
                          child: Text(
                            'Google Sign in',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            context.read<userCubit>().signInwithGoogle();
                          })),
                  const SizedBox(
                    height: 10.0,
                  ),
                  BlocListener<userCubit, IntailState>(
                      listener: (context, state) {
                        if (state is faceSignInSuccess) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/screen5', (Route<dynamic> route) => false);

                          showToast('Successs');
                        }
                        if (state is faceSignInFail) {
                          showToast('Failure');
                        }
                      },
                      child: FlatButton(
                          child: Text(
                            'Facebook Sign in',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            context.read<userCubit>().signInWithFacebook();
                          })),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                      child: Text(
                        'Email Sign in',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        ShowAlert(context);
                      }),
                  Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: ' Sign up',
                                    style: const TextStyle(
                                        color: Colors.blueAccent, fontSize: 20),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             BlocProvider(
                                        //                 create: (context) =>
                                        //                     userCubit(),
                                        //                 child: signup())));
                                        Navigator.of(context)
                                            .pushNamed('/screen3');
                                      })
                              ]))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  bool isPasswordValid(String password) => password.length == 6;

  bool isEmailValid(email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      return false;
    }
  }

  ShowAlert(context) async {
    final TextEditingController _nameController = TextEditingController();
    AlertDialog alert = AlertDialog(
      actions: [
        BlocBuilder<userCubit, IntailState>(builder: (context, state) {
          return TextField(
            onChanged: (val) {
              BlocProvider.of<userCubit>(context).Emailchanged(val.toString());
            },
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: state is EmailError ? 'pls enter data' : null,
            ),
          );
        }),
        BlocBuilder<userCubit, IntailState>(builder: (context, state) {
          return BlocListener<userCubit, IntailState>(
            listener: (context, state) {
              if (state is SignInWithEmailSucc) {
                showToast('Mail sent Suceess');
              }
              if (state is SignInWithEmailFail) {
                showToast('Mail sent Failure');
              }
            },
            child: ElevatedButton(
              child: Text('Send Mail'),
              onPressed: () async {
                print('mail sent');
                signInWithEmailandLink(_nameController.text,null);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          );
        })
      ],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(create: (context) => userCubit(), child: alert);
      },
    );
  }

  Future signInWithEmailandLink(userEmail,link)async{
    print('signInWithEmailandLink method start');
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
    ).then((value) async {
      print("email sent");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('emailis', _userEmail);
      showToast("Email sent");
      print('signInWithEmailandLink method End');
      // _retrieveDynamicLink();
    }).catchError(() {
      showToast("Email not sent");
    }
    );
  }





  Future<String?> _retrieveDynamicLink() async {
    try {
      print('retrive login page mehod');
      final data = await FirebaseDynamicLinks.instance.getInitialLink();
      if(data != null) {
        print('Data =' + data.toString());
        final Uri? deepLink = data.link;
        print('Deep Link =' + deepLink.toString());
        if (deepLink != null) {
          _link = deepLink.toString();
          print('_sign in call time');
          _signInWithEmailAndLink();
        }
        return deepLink.toString();
      }else{
        print('data not found Login page');
      }
    }catch (e){
      print(e);
      print('retrive error');
    }
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = await user.isSignInWithEmailLink(_link!);
    if (validLink) {
      try {
        print('Login _sign method');
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
      } catch (e) {
        print(e);
      }
    }
  }





}
