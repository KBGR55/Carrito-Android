import 'package:carrito/vistas/carritoView.dart';
import 'package:carrito/vistas/creditCardView.dart';
import 'package:carrito/vistas/exception/Page404.dart';
import 'package:carrito/vistas/menuView.dart';
import 'package:carrito/vistas/registroView.dart';
import 'package:carrito/vistas/sessionView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: sessionView(),
      initialRoute: '/home',
      routes:{
        '/home': (context) => sessionView(),
        '/principal': (context)=> menuView(),
        '/registro': (context)=> registroView(),
        '/carrito': (context)=> carreitoView(),
        '/creditCard': (context)=> creditCardView(),
      },
      onGenerateRoute: (settings){
        return MaterialPageRoute(builder: (context)=> Page404());
      },
    );
  }
}