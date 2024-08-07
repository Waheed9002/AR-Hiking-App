import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiking/screens/EmergencyServices.dart';
import 'package:hiking/screens/Hiking_saf.dart';
import 'package:hiking/screens/WeatherInfo.dart';
import 'weather_view.dart';

class WeatherEmergency extends StatelessWidget {
  const WeatherEmergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather & Emergency Services',
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 8,
                margin: EdgeInsets.only(bottom: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // Adjust width to 90% of the screen
                    height: 300, // Increased height for the image card
                    child: FittedBox(
                      fit: BoxFit.cover, // Adjust image fitting
                      child: Image.asset(
                        'assets/images/mob.png',
                      ),
                    ),
                  ),
                ),
              ),
              // Buttons Card
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 8,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedButton(
                            text: 'Weather Information',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeatherView(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          AnimatedButton(
                            text: 'Safety Tips',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HikingTips(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          AnimatedButton(
                            text: 'Emergency Services',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmergencyServices(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedButton({required this.text, required this.onPressed, Key? key}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black54,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            shadowColor: Colors.blueAccent.withOpacity(0.5),
            elevation: 8,
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
