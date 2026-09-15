// import 'dart:io';

// class SaveMaterialParameter {
//   final List<File> materials;
//   final int staffId;
//   final String accYear;
//   final List<StandardDivisionParameter> standardId;
//   final int subjectId;
//   final int branchId;
//   final int createdUser;
//   final String documentName;
//   final String notes;
//   final String link;
//   final bool favorite;

//   const SaveMaterialParameter({
//     required this.materials,
//     required this.staffId,
//     required this.accYear,
//     required this.standardId,
//     required this.subjectId,
//     required this.branchId,
//     required this.createdUser,
//     required this.documentName,
//     required this.notes,
//     required this.link,
//     required this.favorite,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'StaffId': staffId,
//       'AccYear': accYear,
//       'StandardId': standardId.map((item) => item.toJson()).toList(),
//       'SubjectId': subjectId,
//       'branchId': branchId,
//       'CreatedUser': createdUser,
//       'documentName': documentName,
//       'notes': notes,
//       'link': link,
//       'favorite': favorite,
//       'Material': materials,
//     };
//   }
// }

// class StandardDivisionParameter {
//   final int standardId;
//   final int divisionId;

//   const StandardDivisionParameter({
//     required this.standardId,
//     required this.divisionId,
//   });

//   Map<String, dynamic> toJson() {
//     return {'StandardId': standardId, 'DivisionId': divisionId};
//   }
// }
class SaveMaterialParameter {
  final int staffId;
  final String accYear;
  final List<StandardDivisionParameter> standardId;
  final int subjectId;
  final int branchId;
  final int createdUser;
  final String documentName;
  final String notes;
  final String link;
  final bool favorite;
  final List<dynamic> material;

  const SaveMaterialParameter({
    required this.staffId,
    required this.accYear,
    required this.standardId,
    required this.subjectId,
    required this.branchId,
    required this.createdUser,
    required this.documentName,
    required this.notes,
    required this.link,
    required this.favorite,
    required this.material,
  });

  Map<String, dynamic> toJson() {
    return {
      'StaffId': staffId,
      'AccYear': accYear,
      'StandardId': standardId.map((item) => item.toJson()).toList(),
      'SubjectId': subjectId,
      'branchId': branchId,
      'CreatedUser': createdUser,
      'documentName': documentName,
      'notes': notes,
      'link': link,
      'favorite': favorite,
      'Material': material,
    };
  }
}

class StandardDivisionParameter {
  final int standardId;
  final int divisionId;

  const StandardDivisionParameter({
    required this.standardId,
    required this.divisionId,
  });

  Map<String, dynamic> toJson() {
    return {'StandardId': standardId, 'DivisionId': divisionId};
  }
}
