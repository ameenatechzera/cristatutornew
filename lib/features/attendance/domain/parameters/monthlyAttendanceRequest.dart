import 'package:equatable/equatable.dart';

class MonthlyAttendanceRequest extends Equatable {
  MonthlyAttendanceRequest({
    required this.month,
    required this.accYear,
    required this.standardId,
    required this.divisionId,
    required this.branchId,
  });

  final int month;
  static const String monthKey = "month";

  final String accYear;
  static const String accYearKey = "accYear";

  final dynamic standardId;
  static const String standardIdKey = "standardId";

  final dynamic divisionId;
  static const String divisionIdKey = "divisionId";

  final int branchId;
  static const String branchIdKey = "branchId";


  MonthlyAttendanceRequest copyWith({
    int? month,
    String? accYear,
    dynamic? standardId,
    dynamic? divisionId,
    int? branchId,
  }) {
    return MonthlyAttendanceRequest(
      month: month ?? this.month,
      accYear: accYear ?? this.accYear,
      standardId: standardId ?? this.standardId,
      divisionId: divisionId ?? this.divisionId,
      branchId: branchId ?? this.branchId,
    );
  }

  factory MonthlyAttendanceRequest.fromJson(Map<String, dynamic> json){
    return MonthlyAttendanceRequest(
      month: json["month"] ?? 0,
      accYear: json["accYear"] ?? "",
      standardId: json["standardId"],
      divisionId: json["divisionId"],
      branchId: json["branchId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "month": month,
    "accYear": accYear,
    "standardId": standardId,
    "divisionId": divisionId,
    "branchId": branchId,
  };

  @override
  String toString(){
    return "$month, $accYear, $standardId, $divisionId, $branchId, ";
  }

  @override
  List<Object?> get props => [
    month, accYear, standardId, divisionId, branchId, ];
}
