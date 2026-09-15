// class SaveDiaryParameter {
//   final String accYear;
//   final int standardId;
//   final int divisionId;
//   final int subjectId;
//   final int employeeId;
//   final int? diaryType;
//   final String diaryTitle;
//   final String description;
//   final String diaryDate;
//   final String dueDate;
//   final bool isActive;
//   final bool isFavourite;
//   final int branchId;
//   final String createdUser;
//   final List<String> files;
//   final String videoUrl;

//   const SaveDiaryParameter({
//     required this.accYear,
//     required this.standardId,
//     required this.divisionId,
//     required this.subjectId,
//     required this.employeeId,
//     this.diaryType,
//     required this.diaryTitle,
//     required this.description,
//     required this.diaryDate,
//     required this.dueDate,
//     required this.isActive,
//     required this.isFavourite,
//     required this.branchId,
//     required this.createdUser,
//     required this.files,
//     required this.videoUrl,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "AccYear": accYear,
//       "StandardId": standardId,
//       "DivisionId": divisionId,
//       "SubjectId": subjectId,
//       "EmployeeId": employeeId,
//       "diaryType": diaryType,
//       "diaryTitle": diaryTitle,
//       "Description": description,
//       "diaryDate": diaryDate,
//       "dueDate": dueDate,
//       "isActive": isActive,
//       "isFavourite": isFavourite,
//       "branchId": branchId,
//       "CreatedUser": createdUser,
//       "files": files,
//       "videoUrl": videoUrl,
//     };
//   }
// }
class SaveDiaryParameter {
  final String accYear;
  final List<DiaryStandardDivisionParameter> standardId;
  final int subjectId;
  final int employeeId;
  final String diaryType;
  final String diaryTitle;
  final String description;
  final String diaryDate;
  final String dueDate;
  final bool isActive;
  final bool isFavourite;
  final int branchId;
  final int createdUser;
  final String videoUrl;
  final List<String> files;

  const SaveDiaryParameter({
    required this.accYear,
    required this.standardId,
    required this.subjectId,
    required this.employeeId,
    required this.diaryType,
    required this.diaryTitle,
    required this.description,
    required this.diaryDate,
    required this.dueDate,
    required this.isActive,
    required this.isFavourite,
    required this.branchId,
    required this.createdUser,
    required this.videoUrl,
    required this.files,
  });

  Map<String, dynamic> toJson() {
    return {
      'AccYear': accYear,
      'StandardId': standardId
          .map((DiaryStandardDivisionParameter item) => item.toJson())
          .toList(),
      'SubjectId': subjectId,
      'EmployeeId': employeeId,
      'diaryType': diaryType,
      'diaryTitle': diaryTitle,
      'Description': description,
      'diaryDate': diaryDate,
      'dueDate': dueDate,
      'isActive': isActive,
      'isFavourite': isFavourite,
      'branchId': branchId,
      'CreatedUser': createdUser,
      'videoUrl': videoUrl,
      'files': files,
    };
  }
}

class DiaryStandardDivisionParameter {
  final int standardId;
  final int divisionId;

  const DiaryStandardDivisionParameter({
    required this.standardId,
    required this.divisionId,
  });

  Map<String, dynamic> toJson() {
    return {'StandardId': standardId, 'DivisionId': divisionId};
  }
}
