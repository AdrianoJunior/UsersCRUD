import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_crud/pages/splash/splash_page.dart';
import 'package:users_crud/provider/users_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Users CRUD';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (BuildContext context) => UsersProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: Color(0xFFf6f5ee),
          ),
          home: SplashPage(),
        ),
      );
}
