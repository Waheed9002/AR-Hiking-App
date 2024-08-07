// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class DiscoverSelector extends StatefulWidget {
  @override
  _DiscoverSelectorState createState() => _DiscoverSelectorState();
}

class _DiscoverSelectorState extends State<DiscoverSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 33, vertical: 24),
      child: Container(
        width: double.infinity,
        //color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Discover',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text('Trending Activities nearbuy',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.35))),
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
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
    );
  }
}
