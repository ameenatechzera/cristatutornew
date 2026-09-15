import 'package:cristalteacher/features/attendance/data/datasources/attendancedetails_remote_data_source.dart';
import 'package:cristalteacher/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:cristalteacher/features/attendance/domain/repositories/attendancedetails_repository.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetch_attendance_report_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetch_attendancedetails_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetch_student_attendance_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/save_attendance_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/update_studentattendance_usecase.dart';
import 'package:cristalteacher/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:cristalteacher/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:cristalteacher/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:cristalteacher/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_accyear_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_branch_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_dashboard_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_school_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_tutorshipclass_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/login_usecase.dart';
import 'package:cristalteacher/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:cristalteacher/features/diary/data/datasources/diary_remote_data_source.dart';
import 'package:cristalteacher/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:cristalteacher/features/diary/domain/repositories/diary_repository.dart';
import 'package:cristalteacher/features/diary/domain/usecases/delete_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/fetch_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/save_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/update_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/updatelisting_usecase.dart';
import 'package:cristalteacher/features/diary/presentation/cubit/diary_cubit.dart';
import 'package:cristalteacher/features/earlygoing/data/datasources/gatepass_remote_data_source.dart';
import 'package:cristalteacher/features/earlygoing/data/repositories/gatepass_repository_impl.dart';
import 'package:cristalteacher/features/earlygoing/domain/repositories/gatepass_repository.dart';
import 'package:cristalteacher/features/earlygoing/domain/usecases/fetch_gatepass_usecase.dart';
import 'package:cristalteacher/features/earlygoing/domain/usecases/update_gatepass_usecase.dart';
import 'package:cristalteacher/features/earlygoing/presentation/cubit/gatepass_cubit.dart';
import 'package:cristalteacher/features/exam/data/datasources/exam_management_remote_data_source.dart';
import 'package:cristalteacher/features/exam/data/repositories/exam_management_repository_impl.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';
import 'package:cristalteacher/features/exam/domain/usecases/delete_exam_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/fetch_examlist_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/fetch_examterm_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/fetch_examtype_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/saveexam_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/update_exam_usecase.dart';
import 'package:cristalteacher/features/exam/presentation/cubit/exammanagement_cubit.dart';
import 'package:cristalteacher/features/exams/data/datasources/exam_remote_data_source.dart';
import 'package:cristalteacher/features/exams/data/repositories/exam_repository_impl.dart';
import 'package:cristalteacher/features/exams/domain/repositories/exam_repository.dart';
import 'package:cristalteacher/features/exams/domain/usecases/delete_exam_usecase.dart';
import 'package:cristalteacher/features/exams/domain/usecases/fetch_exam_usecase.dart';
import 'package:cristalteacher/features/exams/domain/usecases/fetch_examentrydetialsforupdate_usecase.dart';
import 'package:cristalteacher/features/exams/domain/usecases/fetch_gradeplans_usecase.dart';
import 'package:cristalteacher/features/exams/domain/usecases/get_all_exams_usecase.dart';
import 'package:cristalteacher/features/exams/domain/usecases/save_exammarks_usecase.dart';
import 'package:cristalteacher/features/exams/domain/usecases/update_exam_usecase.dart';
import 'package:cristalteacher/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:cristalteacher/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:cristalteacher/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:cristalteacher/features/feed/domain/repository/feed_repository.dart';
import 'package:cristalteacher/features/feed/domain/usecases/delete_feed_usecase.dart';
import 'package:cristalteacher/features/feed/domain/usecases/fetch_feed_usecase.dart';
import 'package:cristalteacher/features/feed/domain/usecases/save_feed_usecase.dart';
import 'package:cristalteacher/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:cristalteacher/features/materials/data/datasources/materials_remote_data_source.dart';
import 'package:cristalteacher/features/materials/data/repositories/material_repository_impl.dart.dart';
import 'package:cristalteacher/features/materials/domain/repository/material_repository.dart';
import 'package:cristalteacher/features/materials/domain/usecases/fetch_material_usecase.dart';
import 'package:cristalteacher/features/materials/domain/usecases/save_material_usecase.dart';
import 'package:cristalteacher/features/materials/presentation/cubit/material_cubit.dart';
import 'package:cristalteacher/features/timetable/data/datasources/timetable_remote_datasource.dart';
import 'package:cristalteacher/features/timetable/data/repositories/teacher_timetable_repository_impl.dart';
import 'package:cristalteacher/features/timetable/domain/repositories/teacher_timetable_repository.dart';
import 'package:cristalteacher/features/timetable/domain/usecases/fetch_teacher_timetable_usecase.dart';
import 'package:cristalteacher/features/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:cristalteacher/features/workplan/data/datasources/workplan_remote_data_source.dart';
import 'package:cristalteacher/features/workplan/data/repositories/workplan_repository_impl.dart';
import 'package:cristalteacher/features/workplan/domain/repositories/workplan_repository.dart';
import 'package:cristalteacher/features/workplan/domain/usecases/fetch_workplan_usecase.dart';
import 'package:cristalteacher/features/workplan/domain/usecases/fetch_workplandetails_usecase.dart';
import 'package:cristalteacher/features/workplan/domain/usecases/save_workplan_usecase.dart';
import 'package:cristalteacher/features/workplan/presentation/cubit/workplan_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Cubit
  sl.registerFactory(
    () => AuthenticationCubit(
      loginUseCase: sl(),
      fetchSchoolUseCase: sl(),
      getBranchUseCase: sl(),
      fetchTutorshipClassUseCase: sl(),
      fetchAccYearUseCase: sl(),
      fetchDashboardUseCase: sl(),
    ),
  );

  /// UseCase
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton<FetchSchoolUseCase>(() => FetchSchoolUseCase(sl()));

  sl.registerLazySingleton<GetBranchUseCase>(() => GetBranchUseCase(sl()));
  sl.registerLazySingleton<FetchTutorshipClassUseCase>(
    () => FetchTutorshipClassUseCase(sl()),
  );
  sl.registerLazySingleton(() => FetchAccYearUseCase(sl()));
  sl.registerLazySingleton(() => FetchDashboardUseCase(sl()));

  /// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  /// Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerFactory<DiaryCubit>(
    () => DiaryCubit(
      fetchDiaryUseCase: sl(),
      saveDiaryUseCase: sl(),
      deleteDiaryUseCase: sl(),
      fetchDiaryUpdateListingUseCase: sl(),
      updateDiaryUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<FetchDiaryUseCase>(() => FetchDiaryUseCase(sl()));
  sl.registerLazySingleton<SaveDiaryUseCase>(() => SaveDiaryUseCase(sl()));
  sl.registerLazySingleton<DeleteDiaryUseCase>(() => DeleteDiaryUseCase(sl()));
  sl.registerLazySingleton<FetchDiaryUpdateListingUseCase>(
    () => FetchDiaryUpdateListingUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateDiaryUseCase>(() => UpdateDiaryUseCase(sl()));

  sl.registerLazySingleton<DiaryRepository>(() => DiaryRepositoryImpl(sl()));

  sl.registerLazySingleton<DiaryRemoteDataSource>(
    () => DiaryRemoteDataSourceImpl(),
  );

  /// ================= Attendance =================

  sl.registerFactory(
    () => AttendanceCubit(
      attendanceDetailsUseCase: sl(),
      saveAttendanceUseCase: sl(),
      fetchAttendanceReportUseCase: sl(),
      fetchStudentAttendanceUseCase: sl(),
      updateStudentAttendanceUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => AttendanceDetailsUseCase(sl()));
  sl.registerLazySingleton(() => SaveAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => FetchAttendanceReportUseCase(sl()));
  sl.registerLazySingleton(() => FetchStudentAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStudentAttendanceUseCase(sl()));

  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(),
  );

  /// ================= Feed =================

  sl.registerFactory(
    () => FeedCubit(
      fetchFeedUseCase: sl(),
      saveFeedUseCase: sl(),
      deleteFeedUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => FetchFeedUseCase(sl()));
  sl.registerLazySingleton(() => SaveFeedUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFeedUseCase(sl()));

  sl.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl(sl()));

  sl.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(),
  );

  /// Cubit
  sl.registerFactory(
    () => MaterialCubit(fetchMaterialUseCase: sl(), saveMaterialUseCase: sl()),
  );

  /// UseCase
  sl.registerLazySingleton(() => FetchMaterialUseCase(sl()));
  sl.registerLazySingleton(() => SaveMaterialUseCase(sl()));

  /// Repository
  sl.registerLazySingleton<MaterialRepository>(
    () => MaterialRepositoryImpl(remoteDataSource: sl()),
  );

  /// Remote Data Source
  sl.registerLazySingleton<MaterialRemoteDataSource>(
    () => MaterialRemoteDataSourceImpl(),
  );

  /// Cubit
  sl.registerFactory(
    () => ExamCubit(
      fetchExamUseCase: sl(),
      fetchGradePlanUseCase: sl(),
      getAllExamUseCase: sl(),
      saveExamMarksUseCase: sl(),
      deleteExamMarkUseCase: sl(),
      updateMarkEntryUseCase: sl(),
      fetchMarkEntryDetailsUseCase: sl(),
    ),
  );

  /// UseCase
  sl.registerLazySingleton(() => FetchExamUseCase(sl()));
  sl.registerLazySingleton(() => FetchGradePlanUseCase(sl()));
  sl.registerLazySingleton(() => GetAllExamUseCase(sl()));
  sl.registerLazySingleton(() => SaveExamMarksUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExamMarkUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMarkEntryUseCase(sl()));
  sl.registerLazySingleton(() => FetchMarkEntryDetailsUseCase(sl()));

  /// Repository
  sl.registerLazySingleton<ExamRepository>(() => ExamRepositoryImpl(sl()));

  /// Remote Data Source
  sl.registerLazySingleton<ExamRemoteDataSource>(
    () => ExamRemoteDataSourceImpl(),
  );

  /// ================= Timetable =================

  sl.registerFactory(() => TimetableCubit(fetchTeacherTimetableUseCase: sl()));

  sl.registerLazySingleton(() => FetchTeacherTimetableUseCase(sl()));

  sl.registerLazySingleton<TeacherTimetableRepository>(
    () => TeacherTimetableRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<TeacherTimetableRemoteDataSource>(
    () => TeacherTimetableRemoteDataSourceImpl(),
  );

  /// ================= Gate Pass =================

  sl.registerFactory(
    () =>
        GatepassCubit(fetchGatePassUseCase: sl(), updateGatePassUseCase: sl()),
  );

  sl.registerLazySingleton(() => FetchGatePassUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGatePassUseCase(sl()));

  sl.registerLazySingleton<GatePassRepository>(
    () => GatePassRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GatePassRemoteDataSource>(
    () => GatePassRemoteDataSourceImpl(),
  );

  /// ================= Work Plan =================

  sl.registerFactory(
    () => WorkplanCubit(
      fetchWorkPlanUseCase: sl(),
      fetchWorkPlanDetailsUseCase: sl(),
      saveWorkPlanUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => FetchWorkPlanUseCase(sl()));
  sl.registerLazySingleton(() => FetchWorkPlanDetailsUseCase(sl()));
  sl.registerLazySingleton(() => SaveWorkPlanUseCase(sl()));

  sl.registerLazySingleton<WorkPlanRepository>(
    () => WorkPlanRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<WorkPlanRemoteDataSource>(
    () => WorkPlanRemoteDataSourceImpl(),
  );

  /// ================= Exam Management =================

  /// Cubit
  sl.registerFactory(
    () => ExamManagementCubit(
      fetchExamListingUseCase: sl(),
      getExamTypesUseCase: sl(),
      getExamTermsUseCase: sl(),
      saveExamUseCase: sl(),
      deleteExamUseCase: sl(),
      updateExamUseCase: sl(),
    ),
  );

  /// Use Case
  sl.registerLazySingleton(() => FetchExamListingUseCase(sl()));
  sl.registerLazySingleton(() => GetExamTypesUseCase(sl()));
  sl.registerLazySingleton(() => GetExamTermsUseCase(sl()));
  sl.registerLazySingleton(() => SaveExamUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExamUseCase(sl()));

  /// Repository
  sl.registerLazySingleton<ExamManagementRepository>(
    () => ExamManagementRepositoryImpl(sl()),
  );

  /// Remote Data Source
  sl.registerLazySingleton<ExamManagementRemoteDataSource>(
    () => ExamManagementRemoteDataSourceImpl(),
  );
}
