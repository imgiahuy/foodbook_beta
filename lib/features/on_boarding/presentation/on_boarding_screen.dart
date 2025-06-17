import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        brightness: Brightness.light,
      ),
      home: Scaffold(
        backgroundColor: Color.fromRGBO(247, 217, 21, 1),
        //!Maybe should wrap with a SafeArea
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 300,
                  width: 250,
                  child: Center(
                    child: Text(
                      "What eat today ?",
                      style: TextStyle(
                        fontSize: 70,
                        height: 0.9,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 250, 74, 12),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -5,
                bottom: -110,
                child: Stack(
                  children: [
                    SizedBox(
                      child: Image.asset(
                        'assets/images/get_started_thinking_freebg.png',
                        height: 700,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
