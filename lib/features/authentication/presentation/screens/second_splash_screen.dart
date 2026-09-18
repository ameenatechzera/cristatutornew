import 'package:cristalteacher/features/authentication/presentation/screens/third_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondSplashScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const SecondSplashScreen({super.key, this.onBack, this.onNext});

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
          final double scale = screenWidth / 367;

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              /*
               * CENTER PURPLE BACKGROUND SHAPE
               */
              Positioned(
                top: 0,
                left: screenWidth * 0.22,
                child: Container(
                  width: screenWidth * 0.56,
                  height: 385 * scale,
                  decoration: const BoxDecoration(
                    color: backgroundPurple,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
              ),

              /*
               * LARGE LIGHT BACKGROUND SVG
               */
              Positioned(
                left: -screenWidth * 0.20,
                top: screenHeight * 0.34,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.50,
                    child: SvgPicture.asset(
                      'assets/icons/Vector (1).svg',
                      width: screenWidth * 1.20,
                      height: screenHeight * 0.57,
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
                     * CLASSROOM ILLUSTRATION
                     */
                    Positioned(
                      top: 60 * scale,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/image 57.png',
                        width: screenWidth,
                        height: 285 * scale,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Second splash image error: $error');

                          return SizedBox(
                            height: 285 * scale,
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
                    // Positioned(
                    //   top: 390 * scale,
                    //   left: 24,
                    //   right: 24,
                    //   child: Text(
                    //     'Manage Your\nClasses',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontFamily: 'SansitaOne',
                    //       color: primaryPurple,
                    //       fontSize: 18 * scale,
                    //       height: 1.15,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                    /*
 * HEADING
 */
                    Positioned(
                      top: 390 * scale,
                      left: 24,
                      right: 24,
                      child: Text(
                        'Manage Your\nClasses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryPurple,
                          fontSize: 18 * scale,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    /*
                     * BOLD DESCRIPTION
                     */
                    Positioned(
                      top: 448 * scale,
                      left: 18,
                      right: 18,
                      child: Text(
                        'Marks And Attendance Made Simple',
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
                      top: 485 * scale,
                      left: 24,
                      right: 24,
                      child: Text(
                        'Enter Student Marks, Update Attendance,\n'
                        'And Manage Your Class Information Anytime, Anywhere.',
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

                          // Second page is selected.
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: primaryPurple,
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
                        ],
                      ),
                    ),

                    /*
                     * BACK BUTTON
                     */
                    Positioned(
                      left: 14,
                      bottom: 19,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (onBack != null) {
                              onBack!();
                              return;
                            }

                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
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
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
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

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ThirdSplashScreen(),
                              ),
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
