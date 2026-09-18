import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/errors/failure.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/attendance/data/datasources/attendancedetails_remote_data_source.dart';
import 'package:cristalteacher/features/attendance/domain/entities/attendance_report_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/fetch_attendancedetails_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/monthly_attendanceResult.dart';
import 'package:cristalteacher/features/attendance/domain/entities/studentattendance_response_enttiy.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/attendance_report_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/monthlyAttendanceRequest.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/repositories/attendancedetails_repository.dart';
import 'package:dartz/dartz.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remoteDataSource;

  AttendanceRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<AttendanceDetailsEntity> fetchAttendanceDetails(
    AttendanceDetailsRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.fetchAttendanceDetails(request);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> saveAttendance(
    SaveAttendanceRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.saveAttendance(request);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<AttendanceReportEntity> fetchAttendanceReport(
    AttendanceReportParameter params,
  ) async {
    try {
      final response = await _remoteDataSource.fetchAttendanceReport(params);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<StudentAttendanceResponseEntity> fetchStudentAttendance(
    int studentId,
  ) async {
    try {
      final response = await _remoteDataSource.fetchStudentAttendance(
        studentId,
      );

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> updateStudentAttendance(
    UpdateStudentAttendanceParameter params,
    int studentAttendanceMasterId,
  ) async {
    try {
      final response = await _remoteDataSource.updateStudentAttendance(
        studentAttendanceMasterId,
        params,
      );

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  ResultFuture<MonthlyAttendanceResult> fetchMonthlyAttendance(MonthlyAttendanceRequest params)
  async {
    try {
      final response = await _remoteDataSource.fetchMonthlyAttendance(
        params,
      );

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
