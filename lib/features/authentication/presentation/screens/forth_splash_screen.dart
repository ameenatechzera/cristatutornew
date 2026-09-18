import 'dart:math' as math;

import 'package:cristalteacher/features/authentication/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FourthSplashScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const FourthSplashScreen({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF817BE3);
    const Color backgroundPurple = Color(0xFFBDBCFF);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          // Original design width.
          final double scale = screenWidth / 367;

          /*
           * Exact purple shape measurements.
           */
          final double shapeWidth = 340 * scale;
          final double shapeHeight = 200 * scale;
          final double angle = 33.41 * math.pi / 180;

          /*
           * Calculate the complete size of the rotated shape.
           */
          final double rotatedWidth =
              (shapeWidth * math.cos(angle)).abs() +
              (shapeHeight * math.sin(angle)).abs();

          final double rotatedHeight =
              (shapeWidth * math.sin(angle)).abs() +
              (shapeHeight * math.cos(angle)).abs();

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              /*
               * EXACT PURPLE BACKGROUND SHAPE
               *
               * Width: 367
               * Height: 180
               * Left: -148
               * Top: 43
               * Rotation: 33.41 degrees
               * Right radius: 111.5
               * Color: #BDBCFF
               */
              Positioned(
                left: -170 * scale,
                top: 68 * scale,
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
                        color: backgroundPurple,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(111.5 * scale),
                          bottomRight: Radius.circular(111.5 * scale),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /*
               * LARGE LIGHT BACKGROUND SVG
               */
              Positioned(
                left: -screenWidth * 0.20,
                top: screenHeight * 0.39,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.50,
                    child: SvgPicture.asset(
                      'assets/icons/Vector (1).svg',
                      width: screenWidth * 1.20,
                      height: screenHeight * 0.53,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    /*
                     * MAIN ILLUSTRATION
                     */
                    Positioned(
                      top: 67 * scale,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/image 59.png',
                        width: screenWidth,
                        height: 300 * scale,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Fourth splash image error: $error');

                          return SizedBox(
                            height: 300 * scale,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 80,
                                color: primaryPurple,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /*
                     * HEADING
                     */
                    Positioned(
                      top: 393 * scale,
                      left: 24,
                      right: 24,
                      child: Text(
                        'Stay Connected\nWith Your School',
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

                    /*
                     * BOLD DESCRIPTION
                     */
                    Positioned(
                      top: 457 * scale,
                      left: 18,
                      right: 18,
                      child: Text(
                        'All School Activity In One Place',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF111115),
                          fontSize: 11.5 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    /*
                     * SMALL DESCRIPTION
                     */
                    Positioned(
                      top: 495 * scale,
                      left: 22,
                      right: 22,
                      child: Text(
                        'Stay Updated With School Events, Feeds, Leave Requests,\n'
                        'And Important Notifications — All In One App.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF505056),
                          fontSize: 10 * scale,
                          height: 1.55,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    /*
                     * PAGE INDICATOR
                     */
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
                              color: Color(0xFFD1D1D6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD1D1D6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD1D1D6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 3),

                          // Fourth screen is selected.
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: primaryPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*
                     * NEXT BUTTON
                     */
                    Positioned(
                      right: 14,
                      bottom: 19,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (onNext != null) {
                              onNext!();
                              return;
                            }

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterCodePage(),
                              ),
                              (route) => false,
                            );
                          },
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
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
