import 'package:bloc/bloc.dart';
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/authentication/domain/entities/fetch_accyear_entity.dart';
import 'package:cristalteacher/features/authentication/domain/entities/fetch_branch_entity.dart';
import 'package:cristalteacher/features/authentication/domain/entities/teacher_dashboard_result.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_teacherdashboard_request.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_tutorshipclass_parameter.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_accyear_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_branch_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_dashboard_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_tutorshipclass_usecase.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:cristalteacher/features/authentication/domain/entities/login_entity.dart';
import 'package:cristalteacher/features/authentication/domain/entities/fetch_school_entity.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/login_parameter.dart';
import 'package:cristalteacher/features/authentication/domain/parameters/fetch_school_parameter.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/login_usecase.dart';
import 'package:cristalteacher/features/authentication/domain/usecases/fetch_school_usecase.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final FetchSchoolUseCase _fetchSchoolUseCase;
  final GetBranchUseCase _getBranchUseCase;
  final FetchTutorshipClassUseCase _fetchTutorshipClassUseCase;
  final FetchAccYearUseCase _fetchAccYearUseCase;
  final FetchDashboardUseCase _fetchDashboardUseCase;

  AuthenticationCubit({
    required LoginUseCase loginUseCase,
    required FetchSchoolUseCase fetchSchoolUseCase,
    required GetBranchUseCase getBranchUseCase,
    required FetchTutorshipClassUseCase fetchTutorshipClassUseCase,
    required FetchAccYearUseCase fetchAccYearUseCase,
    required FetchDashboardUseCase fetchDashboardUseCase
  }) : _loginUseCase = loginUseCase,
       _fetchSchoolUseCase = fetchSchoolUseCase,
       _getBranchUseCase = getBranchUseCase,
       _fetchTutorshipClassUseCase = fetchTutorshipClassUseCase,
       _fetchAccYearUseCase = fetchAccYearUseCase,
  _fetchDashboardUseCase = fetchDashboardUseCase,
       super(AuthenticationInitial());

  Future<void> login(LoginRequest request) async {
    print('📘 Login Request: ${request.toJson()}');

    emit(AuthenticationLoading());

    try {
      final result = await _loginUseCase(request);

      result.fold(
        (failure) {
          print('❌ Login Failed: ${failure.message}');
          emit(AuthenticationFailure(failure.message));
        },
        (response) {
          emit(AuthenticationSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during login');
      print(e);
      print(stackTrace);

      emit(const AuthenticationFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchSchools(FetchSchoolRequest request) async {
    print('📘 Fetch School Request: ${request.toJson()}');

    emit(FetchSchoolLoading());

    try {
      final result = await _fetchSchoolUseCase(request);

      result.fold(
        (failure) {
          print('❌ Fetch School Failed');
          print(failure.message);

          emit(FetchSchoolFailure(failure.message));
        },
        (response) async {
          if (response.status == 200 || response.status == 201) {
            final pref = SharedPreferenceHelper();

            final school = response.schoolDetails?.first;

            if (school != null) {
              await pref.setAppStoreVersion(school.appStoreVersion ?? '');

              await pref.setPlayStoreVersion(school.playStoreVersion ?? '');

              await pref.setBaseUrl(school.baseUrl ?? '');

              await pref.setDatabaseName(school.dbName ?? '');

              AppData.schoolName = school.schoolName ?? '';
            }

            emit(FetchSchoolSuccess(response));
          } else {
            emit(FetchSchoolSuccess(response));
          }
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during fetchSchools');
      print(e);
      print(stackTrace);

      emit(const FetchSchoolFailure('An unexpected error occurred'));
    }
  }

  Future<void> getBranchDetails() async {
    emit(GetBranchLoading());

    try {
      final result = await _getBranchUseCase();

      result.fold(
        (failure) {
          print('❌ Get Branch Failed');
          print(failure.message);

          emit(GetBranchFailure(failure.message));
        },
        (response) {
          emit(GetBranchSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during getBranchDetails');
      print(e);
      print(stackTrace);

      emit(const GetBranchFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchTutorshipClass(FetchTutorshipClassRequest request) async {
    print('📘 Fetch Tutorship Class Request: ${request.toJson()}');

    emit(FetchTutorshipClassLoading());

    try {
      final result = await _fetchTutorshipClassUseCase(request);

      result.fold(
        (failure) {
          print('❌ Fetch Tutorship Class Failed');
          print(failure.message);

          emit(FetchTutorshipClassFailure(failure.message));
        },
        (response) {
          emit(FetchTutorshipClassSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during fetchTutorshipClass');
      print(e);
      print(stackTrace);

      emit(const FetchTutorshipClassFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchAccYear() async {
    print('📘 Fetch Academic Year Request');

    emit(FetchAccYearLoading());

    try {
      final result = await _fetchAccYearUseCase();

      result.fold(
        (failure) {
          print('❌ Fetch Academic Year Failed');
          print(failure.message);

          emit(FetchAccYearFailure(failure.message));
        },
        (response) {
          emit(FetchAccYearSuccess(response));
          AppData.saveAccYearsList(
            accYearList: response.data?? <AccYearEntity>[]
          );
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during fetchAccYear');
      print(e);
      print(stackTrace);

      emit(const FetchAccYearFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchTeacherDashboard(TeacherDashboardRequest request) async {
    print('📘 Fetch Dashboard Request: ${request.toJson()}');

    emit(FetchDashboardLoading());

    try {
      final result = await _fetchDashboardUseCase(request);

      result.fold(
            (failure) {
          print('❌ Fetch School Failed');
          print(failure.message);

          emit(FetchDashboardFailure(failure.message));
        },
            (response) async {
          if (response.status == 200 || response.status == 201) {

            emit(FetchDashboardSuccess(response));
          } else {
            emit(FetchDashboardSuccess(response));
          }
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during fetchSchools');
      print(e);
      print(stackTrace);

      emit(const FetchDashboardFailure('An unexpected error occurred'));
    }
  }
}
