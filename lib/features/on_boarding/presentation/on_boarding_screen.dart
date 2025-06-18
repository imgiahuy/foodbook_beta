import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme define later, with this get started we only use once
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
                child: Center(
                  child: Image.asset(
                    'assets/images/food_plate.png',
                    fit: BoxFit.cover,
                    height: 420,
                  ),
                ),
              ),
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
                child: SizedBox(
                  child: Image.asset(
                    'assets/images/get_started_thinking_freebg.png',
                    height: 700,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 50,
                right: 50,
                bottom: 50,
                child: SizedBox(
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Get started",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 250, 74, 12),
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
