import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_cubit.dart';
import 'package:signup_firebase/features/presentaion/cubit/user_state.dart';

class FaceBookPage extends StatelessWidget {
  const FaceBookPage({Key? key}) : super(key: key);

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    //User user=FacebookAuth.instance.getUserData();
        User? user=FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: BlocBuilder<userCubit, IntailState>(builder: (context, state) {
          return Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(user?.email ?? 'Email is not provided'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(user?.phoneNumber ?? 'Phone Number is not provided'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(user?.displayName ?? 'Display name is not provided'),
                  SizedBox(
                    height: 10,
                  ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(user?.photoURL ?? ''),
                  //   radius: 20,
                  // ),
                  BlocListener<userCubit, IntailState>(
                    listener: (context, state) {
                      if (state is FbLogOutSucc) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/screen2', (Route<dynamic> route) => false);
                        showToast('LogOut Success');
                      }
                      if (state is FbLogOutFail) {
                        showToast('LogOut Failure');
                      }
                    }, child:
                  FlatButton(
                    child: Text('Log_Out', style: TextStyle(fontSize: 20.0),),
                    color: Colors.blueAccent,
                    textColor: Colors.green,
                    onPressed: () {
                       context.read<userCubit>().signOutFromFb();
                    },
                  ),
                  ),
                ],
              )
          );
        }
    )
    );
  }
  }
