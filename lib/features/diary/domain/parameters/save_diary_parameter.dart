
class SaveDiaryParameter {
  final String accYear;
  final List<DiaryStandardParameter> standardId;
  final List<DiaryDivisionParameter> divisionId;

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
    required this.divisionId,
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
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'AccYear': accYear,
  //     'StandardId': standardId
  //         .map((DiaryStandardParameter item) => item.toJson())
  //         .toList(),
  //     'DivisionId': divisionId
  //         .map((DiaryDivisionParameter item) => item.toJson())
  //         .toList(),
  //     'SubjectId': subjectId,
  //     'EmployeeId': employeeId,
  //     'diaryType': diaryType,
  //     'diaryTitle': diaryTitle,
  //     'Description': description,
  //     'diaryDate': diaryDate,
  //     'dueDate': dueDate,
  //     'isActive': isActive,
  //     'isFavourite': isFavourite,
  //     'branchId': branchId,
  //     'CreatedUser': createdUser,
  //     'videoUrl': videoUrl,
  //     'files': files,
  //   };
  // }
}

class DiaryStandardParameter {
  final int standardId;
 // final int divisionId;

  const DiaryStandardParameter({
    required this.standardId,
   // required this.divisionId,
  });

  // Map<String, dynamic> toJson() {
  //   return {'StandardId': standardId};
  // }
  Map<String, dynamic> toJson() => {
    'StandardId': standardId,
  };

}
class DiaryDivisionParameter {
  final int divisionId;

  const DiaryDivisionParameter({
    required this.divisionId,
  });

  Map<String, dynamic> toJson()=> {
     'DivisionId': divisionId,
  };
}