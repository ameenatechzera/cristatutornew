// class FetchMaterialParameter {
//   final int subjectId;
//   final String accYear;
//   final String fromDate;
//   final String toDate;
//   final int? staffId;
//   final int branchId;

//   FetchMaterialParameter({
//     required this.subjectId,
//     required this.accYear,
//     required this.fromDate,
//     required this.toDate,
//     this.staffId,
//     required this.branchId,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "subjectId": subjectId,
//       "accYear": accYear,
//       "fromDate": fromDate,
//       "toDate": toDate,
//       "staffId": staffId,
//       "branchId": branchId,
//     };
//   }
// }
class FetchMaterialParameter {
  final int subjectId;
  final String accYear;
  final String fromDate;
  final String toDate;
  final int? staffId;
  final int branchId;
  final int standardId;
  final int divisionId;

  FetchMaterialParameter({
    required this.subjectId,
    required this.accYear,
    required this.fromDate,
    required this.toDate,
    this.staffId,
    required this.branchId,
    required this.standardId,
    required this.divisionId,
  });

  Map<String, dynamic> toJson() {
    return {
      "subjectId": subjectId,
      "accYear": accYear,
      "fromDate": fromDate,
      "toDate": toDate,
      "staffId": staffId,
      "branchId": branchId,
      "standardId": standardId,
      "divisionId": divisionId,
    };
  }
}
