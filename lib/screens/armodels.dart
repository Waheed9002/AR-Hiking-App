import 'package:flutter/material.dart';
import 'package:hiking/screens/walkingar.dart';

import 'idelar.dart';
import 'mountainar.dart';



class Armodels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rows Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/screen1': (context) => idelar(),
        '/screen2': (context) => walkingar(),
        '/screen3': (context) => Mountainar(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ar Models'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/screen1');
            },
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.blueAccent,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/idel.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Go to idel state',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/screen2');
            },
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.greenAccent,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/walking.jpeg",
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Go to walking State ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/screen3');
            },
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.greenAccent,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/mountain.jpg',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'check Mountain View',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}