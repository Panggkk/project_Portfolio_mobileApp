import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Center(
        child: Text('Main Page')
        ),
       backgroundColor: Colors.purpleAccent,
       
      ),
     body: Container(
        color: const Color.fromARGB(255, 255, 255, 255), // เปลี่ยนสีพื้นหลัง
        child: Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
