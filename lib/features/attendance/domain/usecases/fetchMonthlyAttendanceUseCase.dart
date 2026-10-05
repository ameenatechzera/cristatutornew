import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/attendance/domain/entities/monthly_attendance_result.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/monthly_attendance_request.dart';
import 'package:cristalteacher/features/attendance/domain/repositories/attendancedetails_repository.dart';

class FetchMonthlyAttendanceUseCase {
  final AttendanceRepository _repository;

  FetchMonthlyAttendanceUseCase(this._repository);

  ResultFuture<MonthlyAttendanceResult> call(MonthlyAttendanceRequest request) {
    return _repository.fetchMonthlyAttendance(request);
  }
}
