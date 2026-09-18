import 'dart:math' as math;

import 'package:cristalteacher/features/authentication/presentation/screens/second_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstSplashScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const FirstSplashScreen({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF817BE3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          // Figma frame width.
          final double scale = screenWidth / 367;

          // Exact Figma shape measurements.
          final double shapeWidth = 367 * scale;
          final double shapeHeight = 195 * scale;
          final double angle = 33.41 * math.pi / 180;

          // Visible size after rotation.
          final double rotatedWidth =
              (shapeWidth * math.cos(angle)).abs() +
              (shapeHeight * math.sin(angle)).abs();

          final double rotatedHeight =
              (shapeWidth * math.sin(angle)).abs() +
              (shapeHeight * math.cos(angle)).abs();

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Exact rotated background shape.
              Positioned(
                left: -148 * scale,
                top: 43 * scale,
                width: rotatedWidth,
                height: rotatedHeight,
                child: Center(
                  child: Transform.rotate(
                    angle: angle,
                    alignment: Alignment.center,
                    child: Container(
                      width: shapeWidth,
                      height: shapeHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBDBCFF),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(111.5 * scale),
                          bottomRight: Radius.circular(111.5 * scale),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Large light SVG pattern.
              Positioned(
                left: -screenWidth * 0.20,
                top: screenHeight * 0.39,
                child: IgnorePointer(
                  child: SvgPicture.asset(
                    'assets/icons/Vector (1).svg',
                    width: screenWidth * 1.20,
                    height: screenHeight * 0.53,
                    fit: BoxFit.contain,
                    // colorFilter: const ColorFilter.mode(
                    //   Color(0xFFEDEDEF),
                    //   BlendMode.srcIn,
                    // ),
                  ),
                ),
              ),

              SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 72 * scale,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/image 50.png',
                        width: screenWidth,
                        height: 300 * scale,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),

                    Positioned(
                      top: 385 * scale,
                      left: 24,
                      right: 24,
                      child: Text(
                        'Welcome To Your\nTeacher App',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryPurple,
                          fontSize: 18 * scale,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 451 * scale,
                      left: 15,
                      right: 15,
                      child: Text(
                        'Everything You Need, Right At Your Fingertips',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF111115),
                          fontSize: 11.5 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 495 * scale,
                      left: 22,
                      right: 22,
                      child: Text(
                        'Manage Your Daily Teaching Activities Quickly And Easily\n'
                        'From One Simple, User-Friendly App.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF505056),
                          fontSize: 10 * scale,
                          height: 1.5,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: primaryPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 3),
                          ...List.generate(
                            3,
                            (_) => Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD1D1D6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      right: 14,
                      bottom: 19,
                      child: GestureDetector(
                        onTap: () {
                          if (onNext != null) {
                            onNext!();
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SecondSplashScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
