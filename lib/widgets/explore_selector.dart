// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class ExploreSelector extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ExploreSelectorState createState() => _ExploreSelectorState();
}

class _ExploreSelectorState extends State<ExploreSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 33, vertical: 24),
      width: double.infinity,
      //color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Explore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
          Text('All destinations',
              style: TextStyle(
                  fontSize: 14, color: Colors.black.withOpacity(0.35))),
        ],
      ),
    );
  }
}
