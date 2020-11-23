import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'DetailsPage.dart';
import 'HomePage.dart';
import 'CreateBlog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
      routes: {
        CreateBlog.ID: (context) => CreateBlog(),
      },
    );
  }
}
