import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:subspace_project/Screens/home_page.dart';
import 'package:subspace_project/Services/favourite_provider.dart';

import 'Services/Bloc/blogs_bloc.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        BlocProvider(create: (context) => BlogsBloc(),),
        ChangeNotifierProvider(create: (context) => BlogFavProvider(),)
      ],
      child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
