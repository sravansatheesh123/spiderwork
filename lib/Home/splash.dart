import 'package:flutter/material.dart';
import 'dart:async';

import 'package:task/Home/home.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(milliseconds: 5000),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    _controller.forward();

    Timer(
        Duration(seconds: 8),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home()) // Replace with your Home widget
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.098),
              Color.fromRGBO(241, 241, 241, 0.294),
            ],
          ),
        ),
        child: Stack(
          children: [
            FadeTransition(
              opacity: _animation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/splashlogo.png",
                      height: 100,
                      width: 180,
                    ),
                    const SizedBox(
                        height: 20), // Space between the image and text
                    const Text(
                      'News Articles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.black, // You can adjust the color as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
