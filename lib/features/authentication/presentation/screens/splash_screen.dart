import 'package:cristalteacher/features/authentication/presentation/screens/first_splash_screen.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/second_splash_screen.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/login_screen.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/register_screen.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/teacherDashboard_screen.dart';
import 'package:cristalteacher/features/diary/presentation/screens/dashboard_screen.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  @override
  void initState() {
    super.initState();
    _decideStartScreen();
  }

  Future<void> _decideStartScreen() async {
    final SharedPreferenceHelper pref = SharedPreferenceHelper();

    final bool isRegistered = await pref.isSchoolRegistered();
    final String? token = await pref.getToken();

    final bool isLoggedIn = token != null && token.trim().isNotEmpty;

    debugPrint('==============================');
    debugPrint('APP START');
    debugPrint('School Registered : $isRegistered');
    debugPrint('Logged In         : $isLoggedIn');
    debugPrint('==============================');

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    if (!isRegistered) {
      _openPage(FirstSplashScreen());
      //_openPage(const RegisterCodePage());
      return;
    }

    if (!isLoggedIn) {
      _openPage(const LoginScreen());
      return;
    }

    // _openPage(TeacherDashboardPage());
    _openPage(TeacherDashboardNewPage());
  }

  void _openPage(Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage('assets/images/cristal_horizontal.png'),
            height: 180,
          ),
        ),
      ),
    );
  }
}
