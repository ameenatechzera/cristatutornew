part of 'attendance_cubit.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}
class MonthlyAttendanceReportLoading extends AttendanceState {}
final class AttendanceSuccess extends AttendanceState {
  final AttendanceDetailsEntity response;

  const AttendanceSuccess(this.response);
}

class MonthlyAttendanceReportFailure extends AttendanceState {
  final String message;

  const MonthlyAttendanceReportFailure(this.message);
}


class MonthlyAttendanceReportSuccess extends AttendanceState {
  final MonthlyAttendanceResult response;

  const MonthlyAttendanceReportSuccess(this.response);
}

final class AttendanceFailure extends AttendanceState {
  final String message;

  const AttendanceFailure(this.message);
}

class SaveAttendanceLoading extends AttendanceState {}

class SaveAttendanceSuccess extends AttendanceState {
  final MasterResponseModel response;

  const SaveAttendanceSuccess(this.response);
}

class SaveAttendanceFailure extends AttendanceState {
  final String message;

  const SaveAttendanceFailure(this.message);
}
// Attendance Report

class AttendanceReportLoading extends AttendanceState {}

class AttendanceReportSuccess extends AttendanceState {
  final AttendanceReportEntity response;

  const AttendanceReportSuccess(this.response);
}

class AttendanceReportFailure extends AttendanceState {
  final String message;

  const AttendanceReportFailure(this.message);
}

class StudentAttendanceLoading extends AttendanceState {}

class StudentAttendanceSuccess extends AttendanceState {
  final StudentAttendanceResponseEntity response;

  const StudentAttendanceSuccess(this.response);
}

class StudentAttendanceFailure extends AttendanceState {
  final String message;

  const StudentAttendanceFailure(this.message);
}

class UpdateStudentAttendanceLoading extends AttendanceState {}

class UpdateStudentAttendanceSuccess extends AttendanceState {
  final MasterResponseModel response;

  const UpdateStudentAttendanceSuccess(this.response);
}

class UpdateStudentAttendanceFailure extends AttendanceState {
  final String message;

  const UpdateStudentAttendanceFailure(this.message);
}
