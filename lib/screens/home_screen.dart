
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hiking/widgets/discover_selector.dart';
import 'package:hiking/widgets/explore_selector.dart';
import 'package:hiking/widgets/grid_selector.dart';
import 'package:hiking/widgets/slider_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            ListView(
              children: <Widget>[
                DiscoverSelector(),
                Center(child: SliderSelector()),
                ExploreSelector(),
                GridSelector(),
              ],
            ),
            Positioned(
              bottom: 0,
              // left: 0,
              // right: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/bottom.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
