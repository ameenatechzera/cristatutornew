class FetchDiaryParameter {
  final int branchId;
  final int? subjectId;
  final String accyear;
  final String fromDate;
  final String toDate;
  final String userId;

  const FetchDiaryParameter({
    required this.branchId,
    this.subjectId,
    required this.accyear,
    required this.fromDate,
    required this.toDate,
    required this.userId,
  });

  factory FetchDiaryParameter.fromJson(Map<String, dynamic> json) {
    return FetchDiaryParameter(
      branchId: json['branchId'] as int,
      subjectId: json['subjectId'] as int?,
      accyear: json['accyear'].toString(),
      fromDate: json['fromDate'].toString(),
      toDate: json['toDate'].toString(),
      userId: json['userId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'subjectId': subjectId,
      'accyear': accyear,
      'fromDate': fromDate,
      'toDate': toDate,
      'userId': userId,
    };
  }

  FetchDiaryParameter copyWith({
    int? branchId,
    int? subjectId,
    String? accyear,
    String? fromDate,
    String? toDate,
    String? userId,
  }) {
    return FetchDiaryParameter(
      branchId: branchId ?? this.branchId,
      subjectId: subjectId ?? this.subjectId,
      accyear: accyear ?? this.accyear,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      userId: userId ?? this.userId,
    );
  }
}

// class FetchDiaryParameter {
//   final int branchId;
//   final int? standardId;
//   final int? divisionId;
//   final String accyear;
//   final String fromDate;
//   final String toDate;
//   final String userId;

//   const FetchDiaryParameter({
//     required this.branchId,
//     this.standardId,
//     this.divisionId,
//     required this.accyear,
//     required this.fromDate,
//     required this.toDate,
//     required this.userId,
//   });

//   factory FetchDiaryParameter.fromJson(Map<String, dynamic> json) {
//     return FetchDiaryParameter(
//       branchId: json['branchId'] as int,
//       standardId: json['standardId'] as int,
//       divisionId: json['divisionId'] as int,
//       accyear: json['accyear'].toString(),
//       fromDate: json['fromDate'].toString(),
//       toDate: json['toDate'].toString(),
//       userId: json['userId'].toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'branchId': branchId,
//       'standardId': standardId,
//       'divisionId': divisionId,
//       'accyear': accyear,
//       'fromDate': fromDate,
//       'toDate': toDate,
//       'userId': userId,
//     };
//   }

//   FetchDiaryParameter copyWith({
//     int? branchId,
//     int? standardId,
//     int? divisionId,
//     String? accyear,
//     String? fromDate,
//     String? toDate,
//     String? userId,
//   }) {
//     return FetchDiaryParameter(
//       branchId: branchId ?? this.branchId,
//       standardId: standardId ?? this.standardId,
//       divisionId: divisionId ?? this.divisionId,
//       accyear: accyear ?? this.accyear,
//       fromDate: fromDate ?? this.fromDate,
//       toDate: toDate ?? this.toDate,
//       userId: userId ?? this.userId,
//     );
//   }
// }
