import 'package:equatable/equatable.dart';

class MonthlyAttendanceResult extends Equatable {
  MonthlyAttendanceResult({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<Map<String, String>> data;
  static const String dataKey = "data";


  MonthlyAttendanceResult copyWith({
    int? status,
    bool? error,
    String? message,
    List<Map<String, String>>? data,
  }) {
    return MonthlyAttendanceResult(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory MonthlyAttendanceResult.fromJson(Map<String, dynamic> json){
    return MonthlyAttendanceResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Map<String, String>>.from(json["data"]!.map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v ?? "")))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "data": data.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v))).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, data, ];
}
