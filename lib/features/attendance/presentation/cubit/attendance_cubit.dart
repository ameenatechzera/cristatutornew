import 'package:bloc/bloc.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/features/attendance/domain/entities/attendance_report_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/fetch_attendancedetails_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/monthly_attendanceResult.dart';
import 'package:cristalteacher/features/attendance/domain/entities/studentattendance_response_enttiy.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/attendance_report_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/monthlyAttendanceRequest.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetchMonthlyAttendanceUseCase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetch_attendance_report_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetch_attendancedetails_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/fetch_student_attendance_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/save_attendance_usecase.dart';
import 'package:cristalteacher/features/attendance/domain/usecases/update_studentattendance_usecase.dart';
import 'package:equatable/equatable.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceDetailsUseCase _attendanceDetailsUseCase;
  final SaveAttendanceUseCase _saveAttendanceUseCase;
  final FetchAttendanceReportUseCase _fetchAttendanceReportUseCase;
  final FetchStudentAttendanceUseCase _fetchStudentAttendanceUseCase;
  final UpdateStudentAttendanceUseCase _updateStudentAttendanceUseCase;
  final FetchMonthlyAttendanceUseCase _fetchMonthlyAttendanceUseCase;

  AttendanceCubit({
    required AttendanceDetailsUseCase attendanceDetailsUseCase,
    required SaveAttendanceUseCase saveAttendanceUseCase,
    required FetchAttendanceReportUseCase fetchAttendanceReportUseCase,
    required FetchStudentAttendanceUseCase fetchStudentAttendanceUseCase,
    required UpdateStudentAttendanceUseCase updateStudentAttendanceUseCase,
    required FetchMonthlyAttendanceUseCase fetchMonthlyAttendanceUseCase
  }) : _attendanceDetailsUseCase = attendanceDetailsUseCase,
       _saveAttendanceUseCase = saveAttendanceUseCase,
       _fetchAttendanceReportUseCase = fetchAttendanceReportUseCase,
       _fetchStudentAttendanceUseCase = fetchStudentAttendanceUseCase,
       _updateStudentAttendanceUseCase = updateStudentAttendanceUseCase,
        _fetchMonthlyAttendanceUseCase = fetchMonthlyAttendanceUseCase,
       super(AttendanceInitial());

  Future fetchMonthlyAttendanceReport(MonthlyAttendanceRequest params) async {
    print('📘 Fetch Attendance Report Called');
    print('📘 Fetch Attendance Report Called');
    print('Request: ${params.toJson()}');

    emit(MonthlyAttendanceReportLoading());

    try {
      final result = await _fetchMonthlyAttendanceUseCase(params);

      result.fold(
            (failure) {
          print('❌ Attendance Report Failed');
          print(failure.message);

          emit(MonthlyAttendanceReportFailure(failure.message));
        },
            (response) {
          print('✅ Attendance Report Success');

          emit(MonthlyAttendanceReportSuccess(response));
        },
      );
    } catch (e, stacktrace) {
      print('❌ Exception during fetchAttendanceReport: $e');
      print(stacktrace);

      emit(const MonthlyAttendanceReportFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchAttendanceDetails(AttendanceDetailsRequest request) async {
    print('📘 AttendanceDetailsRequest: ${request.toJson()}');

    emit(AttendanceLoading());

    try {
      final result = await _attendanceDetailsUseCase(request);

      result.fold(
        (failure) {
          print('❌ Attendance Details Failed');
          print(failure.message);

          emit(AttendanceFailure(failure.message));
        },
        (response) {
          print('✅ Attendance Details Success');

          emit(AttendanceSuccess(response));
        },
      );
    } catch (e, stacktrace) {
      print('❌ Exception during fetchAttendanceDetails: $e');
      print('Stacktrace: $stacktrace');

      emit(const AttendanceFailure('An unexpected error occurred'));
    }
  }

  Future<void> saveAttendance(SaveAttendanceRequest request) async {
    print('📘 SaveAttendanceRequest: ${request.toJson()}');

    emit(SaveAttendanceLoading());

    try {
      final result = await _saveAttendanceUseCase(request);

      result.fold(
        (failure) {
          print('❌ Save Attendance Failed');
          print(failure.message);

          emit(SaveAttendanceFailure(failure.message));
        },
        (response) {
          print('✅ Save Attendance Success');

          emit(SaveAttendanceSuccess(response));
        },
      );
    } catch (e, stacktrace) {
      print('❌ Exception during saveAttendance: $e');
      print(stacktrace);

      emit(const SaveAttendanceFailure('An unexpected error occurred'));
    }
  }

  Future fetchAttendanceReport(AttendanceReportParameter params) async {
    print('📘 Fetch Attendance Report Called');
    print('📘 Fetch Attendance Report Called');
    print('Request: ${params.toJson()}');

    emit(AttendanceReportLoading());

    try {
      final result = await _fetchAttendanceReportUseCase(params);

      result.fold(
        (failure) {
          print('❌ Attendance Report Failed');
          print(failure.message);

          emit(AttendanceReportFailure(failure.message));
        },
        (response) {
          print('✅ Attendance Report Success');

          emit(AttendanceReportSuccess(response));
        },
      );
    } catch (e, stacktrace) {
      print('❌ Exception during fetchAttendanceReport: $e');
      print(stacktrace);

      emit(const AttendanceReportFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchStudentAttendance(int studentId) async {
    print('📘 Fetch Student Attendance Called');
    print('📌 Student ID: $studentId');

    emit(StudentAttendanceLoading());

    try {
      final result = await _fetchStudentAttendanceUseCase(studentId);

      result.fold(
        (failure) {
          print('❌ Student Attendance Failed');
          print(failure.message);

          emit(StudentAttendanceFailure(failure.message));
        },
        (response) {
          print('✅ Student Attendance Success');
          emit(StudentAttendanceSuccess(response));
        },
      );
    } catch (e, stacktrace) {
      print('❌ Exception during fetchStudentAttendance: $e');
      print(stacktrace);

      emit(const StudentAttendanceFailure('An unexpected error occurred'));
    }
  } // ---------------------------------------------------------------------------
  // UPDATE STUDENT ATTENDANCE
  // ---------------------------------------------------------------------------

  Future<void> updateStudentAttendance(
    UpdateStudentAttendanceParameter params,
    int id,
  ) async {
    print('✏️ Update Student Attendance Called');
    print('📌 Attendance ID: $id');
    print('📦 Update Request: ${params.toJson()}');

    emit(UpdateStudentAttendanceLoading());

    try {
      final result = await _updateStudentAttendanceUseCase(params, id);
      result.fold(
        (failure) {
          print('❌ Update Student Attendance Failed');
          print(failure.message);

          emit(UpdateStudentAttendanceFailure(failure.message));
        },
        (response) {
          print('✅ Update Student Attendance Success');

          emit(UpdateStudentAttendanceSuccess(response));
        },
      );
    } catch (e, stacktrace) {
      print('❌ Exception during updateStudentAttendance: $e');
      print(stacktrace);

      emit(
        const UpdateStudentAttendanceFailure('An unexpected error occurred'),
      );
    }
  }
}
