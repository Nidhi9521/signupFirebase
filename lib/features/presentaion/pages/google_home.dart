import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
class GoogleHome extends StatelessWidget {


  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
  @override
  Widget build(BuildContext context) {
     User? user = FirebaseAuth.instance.currentUser;

    return
      Scaffold(
      body: BlocBuilder<userCubit, IntailState>(builder: (context, state) {
        return Center(
          child:
          //user != null ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(user?.getIdToken().toString() ?? 'Email is not provided',style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                Text(user?.phoneNumber ?? 'Phone Number is not provided',style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
                const SizedBox(
                  height: 10,
                ),
                Text(user?.displayName ?? 'Display name is not provided',style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                    backgroundImage: NetworkImage(user?.photoURL ?? 'assets/user.png'),
                    radius: 20,
                  ),
              BlocListener<userCubit, IntailState>(
                  listener: (context, state) {
                    if (state is googleLogOutSucc) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/screen2', (Route<dynamic> route) => false);
                      showToast('LogOut Success');
                    }
                    if (state is googleLogOutFail) {
                      showToast('LogOut Failure');
                    }
                    if (state is FbLogOutSucc) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/screen2', (Route<dynamic> route) => false);
                      showToast('FB LogOut Success');
                    }
                    if (state is FbLogOutFail) {
                      showToast('FB LogOut Failure');
                    }
                  },child:
                  FlatButton(
                    child: const Text('Log_Out', style: TextStyle(fontSize: 20.0),),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<userCubit>().signOutFromGoogle();
                    },
                  ),
              ),
            ],
          )
              //   :
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text(),
              //     //Text(user!.phoneNumber!),
              //     Text(user!.displayName!),
              //     // CircleAvatar(
              //     //   backgroundImage: NetworkImage(user.photoURL!),
              //     //   radius: 20,
              //     // ),
              //     BlocListener<userCubit, IntailState>(
              //       listener: (context, state) {
              //         if (state is googleLogOutSucc) {
              //           Navigator.of(context).pushNamedAndRemoveUntil('/screen2', (Route<dynamic> route) => false);
              //           showToast('LogOut Success');
              //         }
              //         if (state is googleLogOutFail) {
              //           showToast('LogOut Failure');
              //         }
              //       },child:
              //     FlatButton(
              //       child: Text('Log_Out', style: TextStyle(fontSize: 20.0),),
              //       color: Colors.blueAccent,
              //       textColor: Colors.white,
              //       onPressed: () {
              //         context.read<userCubit>().signOutFromGoogle();
              //       },
              //     ),
              //     ),
              //     Text('User is not here')
              //   ],
              // )
        );
      })
    );
  }

}
