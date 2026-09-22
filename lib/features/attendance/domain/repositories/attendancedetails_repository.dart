import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/attendance/domain/entities/attendance_report_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/fetch_attendancedetails_entity.dart';
import 'package:cristalteacher/features/attendance/domain/entities/monthly_attendanceResult.dart';
import 'package:cristalteacher/features/attendance/domain/entities/studentattendance_response_enttiy.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/attendance_report_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/monthlyAttendanceRequest.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';

abstract class AttendanceRepository {
  ResultFuture<AttendanceDetailsEntity> fetchAttendanceDetails(
    AttendanceDetailsRequest request,
  );
  ResultFuture<MasterResponseModel> saveAttendance(
    SaveAttendanceRequest request,
  );
  ResultFuture<AttendanceReportEntity> fetchAttendanceReport(
    AttendanceReportParameter params,
  );
  ResultFuture<StudentAttendanceResponseEntity> fetchStudentAttendance(
    int studentId,
  );
  ResultFuture<MasterResponseModel> updateStudentAttendance(
    UpdateStudentAttendanceParameter params,
    int studentAttendanceMasterId,
  );
  ResultFuture<MonthlyAttendanceResult> fetchMonthlyAttendance(
      MonthlyAttendanceRequest params,
      );

}
