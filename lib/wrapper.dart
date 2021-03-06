import 'package:Tuter/backend/database.dart';
import 'package:Tuter/logIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tuter/home.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final db = DatabaseService();

    Future userType;
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user != null)
      userType = db.getUserType(user.uid);
    else userType = null;

    // decide to either go to log in or home page
    // if (user == null || !user.isEmailVerified)
    //   return LogIn();
    // else 
    //   return NavBar();

    return FutureBuilder(
      future:userType,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        if(snapshot.connectionState == ConnectionState.done && user.isEmailVerified)
            return NavBar(isTutor: snapshot.data);
        else return LogIn();
      }
    );
  }
}