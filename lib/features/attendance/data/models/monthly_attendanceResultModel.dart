import 'package:cristalteacher/features/attendance/domain/entities/monthly_attendanceResult.dart';

class MonthlyAttendanceModel extends MonthlyAttendanceResult{
  MonthlyAttendanceModel({required super.status, required super.error, required super.message, required super.data});

  factory MonthlyAttendanceModel.fromJson(Map<String, dynamic> json){
    return MonthlyAttendanceModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Map<String, String>>.from(json["data"]!.map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v ?? "")))),
    );
  }
}