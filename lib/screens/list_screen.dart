// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hiking/screens/map_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              //color: Colors.green,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Image.asset(
                              'assets/images/backicon.png',
                              height: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Text(
                          'Mountains',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 41,
                          width: 41,
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image(
                                image: AssetImage('assets/images/profile.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(92, 214, 115, 1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(),
                      ),
                    );
                  },
                  child: Container(
                    //color: Colors.lightBlue,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/map.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Check activities\nnearbuy',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                //color: Colors.green,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 100,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/mountainlist.jpg',
                                width: 115,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Mount something',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                    SizedBox(height: 5),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '4.5',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Image.asset('assets/images/stars.png'),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Unlock your full potential with\nour hiking tour. Explore the best\nhiking sights with us!!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
