import 'package:flutter/material.dart';

class Page404 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Page404State();
  }
}

class _Page404State extends State<Page404> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page404"),
      ),
      body: Center(
        child: Text("Page404"),
      ),
    );
  }
}
