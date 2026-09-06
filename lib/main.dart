import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/authentication/presentation/screens/splash_screen.dart';
import 'package:cristalteacher/features/diary/presentation/cubit/diary_cubit.dart';
import 'package:cristalteacher/features/earlygoing/presentation/cubit/gatepass_cubit.dart';
import 'package:cristalteacher/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
import 'package:cristalteacher/features/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:cristalteacher/features/workplan/presentation/cubit/workplan_cubit.dart';
import 'package:cristalteacher/services/service_locator.dart';
import 'package:cristalteacher/services/service_locator.dart' as ServiceLocator;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

void main() async {
  await ServiceLocator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (_) => sl<AuthenticationCubit>(),
        ),
        BlocProvider<DiaryCubit>(create: (_) => sl<DiaryCubit>()),
        BlocProvider<AttendanceCubit>(create: (_) => sl<AttendanceCubit>()),
        BlocProvider<FeedCubit>(create: (_) => sl<FeedCubit>()),
        BlocProvider<MaterialCubit>(create: (_) => sl<MaterialCubit>()),
        BlocProvider<ExamCubit>(create: (_) => sl<ExamCubit>()),
        BlocProvider<TimetableCubit>(create: (_) => sl<TimetableCubit>()),
        BlocProvider<GatepassCubit>(create: (_) => sl<GatepassCubit>()),
        BlocProvider<WorkplanCubit>(create: (_) => sl<WorkplanCubit>()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),

        home: AppStartScreen(),

        //RegisterCodePage(),
        //TeacherDashboardPage(),
      ),
    );
  }
}
