import 'package:flutter/material.dart';
import 'package:users_crud/pages/login/login_page.dart';
import 'package:users_crud/pages/users/users_page.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/utils/nav.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future futureDelay = Future.delayed(Duration(seconds: 3));

    Future futureUser = Usuario.get();

    Future.wait([futureDelay, futureUser]).then((List values) {
      Usuario user = values[1];

      if (user != null) {
        push(context, UsersPage(), replace: true);
      } else {
        push(context, LoginPage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/crud_logo.png'),
          ),
          // SizedBox(height: 32),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
