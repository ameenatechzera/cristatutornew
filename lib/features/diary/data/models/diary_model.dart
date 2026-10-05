// import 'package:cristalteacher/features/diary/domain/entities/diary_entity.dart';

// class DiaryResponseModel extends DiaryResponseEntity {
//   const DiaryResponseModel({
//     super.status,
//     super.error,
//     List<DiaryModel>? super.data,
//   });

//   factory DiaryResponseModel.fromJson(Map<String, dynamic> json) {
//     return DiaryResponseModel(
//       status: json['status'] as int?,
//       error: json['error'] as bool?,
//       data: json['data'] == null
//           ? []
//           : (json['data'] as List)
//                 .map(
//                   (item) => DiaryModel.fromJson(item as Map<String, dynamic>),
//                 )
//                 .toList(),
//     );
//   }
// }

// class DiaryModel extends DiaryEntity {
//   const DiaryModel({
//     required super.diaryId,
//     super.accYear,
//     super.standardId,
//     super.standard,
//     super.divisionId,
//     super.division,
//     super.subjectId,
//     super.subjectName,
//     super.employeeId,
//     super.employeeName,
//     super.diaryType,
//     super.diaryTypeName,
//     super.diaryTitle,
//     super.description,
//     super.diaryDate,
//     super.dueDate,
//     super.isActive,
//     super.isFavourite,
//     super.branchId,
//     super.createdDate,
//     super.createdUser,
//     super.modifiedDate,
//     super.modifiedUser,
//     super.files,
//   });

//   factory DiaryModel.fromJson(Map<String, dynamic> json) {
//     return DiaryModel(
//       diaryId: json['diaryId'] as int? ?? 0,
//       accYear: json['AccYear']?.toString(),
//       standardId: json['StandardId'] as int?,
//       standard: json['Standard']?.toString(),
//       divisionId: json['DivisionId'] as int?,
//       division: json['Division']?.toString(),
//       subjectId: json['SubjectId'] as int?,
//       subjectName: json['SubjectName']?.toString(),
//       employeeId: json['EmployeeId'] as int?,
//       employeeName: json['employeeName']?.toString(),
//       diaryType: json['diaryType'] as int?,
//       diaryTypeName: json['DiaryType']?.toString(),
//       diaryTitle: json['diaryTitle']?.toString(),
//       description: json['Description']?.toString(),
//       diaryDate: json['diaryDate']?.toString(),
//       dueDate: json['dueDate']?.toString(),
//       isActive: json['isActive'] as bool?,
//       isFavourite: json['isFavourite'] as bool?,
//       branchId: json['branchId'] as int?,
//       createdDate: json['CreatedDate']?.toString(),
//       createdUser: json['CreatedUser']?.toString(),
//       modifiedDate: json['ModifedDate']?.toString(),
//       modifiedUser: json['ModifedUser']?.toString(),
//       files: json['files'] == null
//           ? []
//           : List<String>.from(
//               (json['files'] as List).map((item) => item.toString()),
//             ),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'diaryId': diaryId,
//       'AccYear': accYear,
//       'StandardId': standardId,
//       'Standard': standard,
//       'DivisionId': divisionId,
//       'Division': division,
//       'SubjectId': subjectId,
//       'SubjectName': subjectName,
//       'EmployeeId': employeeId,
//       'employeeName': employeeName,
//       'diaryType': diaryType,
//       'DiaryType': diaryTypeName,
//       'diaryTitle': diaryTitle,
//       'Description': description,
//       'diaryDate': diaryDate,
//       'dueDate': dueDate,
//       'isActive': isActive,
//       'isFavourite': isFavourite,
//       'branchId': branchId,
//       'CreatedDate': createdDate,
//       'CreatedUser': createdUser,
//       'ModifedDate': modifiedDate,
//       'ModifedUser': modifiedUser,
//       'files': files,
//     };
//   }
// }
import 'package:cristalteacher/features/diary/domain/entities/diary_entity.dart';

class DiaryResponseModel extends DiaryResponseEntity {
  const DiaryResponseModel({
    super.status,
    super.error,
    List<DiaryModel>? super.data,
  });

  factory DiaryResponseModel.fromJson(Map<String, dynamic> json) {
    return DiaryResponseModel(
      status: json['status'] as int?,
      error: json['error'] as bool?,
      data: json['data'] == null
          ? []
          : (json['data'] as List)
                .map(
                  (item) => DiaryModel.fromJson(item as Map<String, dynamic>),
                )
                .toList(),
    );
  }
}

class DiaryModel extends DiaryEntity {
  const DiaryModel({
    required super.diaryId,
    super.accYear,
    super.standardDivision,
    super.subjectId,
    super.subjectName,
    super.employeeId,
    super.employeeName,
    super.diaryType,
    super.diaryTypeName,
    super.diaryTitle,
    super.description,
    super.diaryDate,
    super.dueDate,
    super.isActive,
    super.isFavourite,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.files,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      diaryId: json['diaryId'] as int? ?? 0,

      accYear: json['AccYear']?.toString(),

      standardDivision: json['StandardDivision'] == null
          ? []
          : (json['StandardDivision'] as List)
                .map(
                  (item) => StandardDivisionModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList(),

      subjectId: json['SubjectId'] as int?,
      subjectName: json['SubjectName']?.toString(),

      employeeId: json['EmployeeId'] as int?,
      employeeName: json['employeeName']?.toString(),

      diaryType: json['diaryType'] as int?,
      diaryTypeName: json['DiaryType']?.toString(),

      diaryTitle: json['diaryTitle']?.toString(),
      description: json['Description']?.toString(),

      diaryDate: json['diaryDate']?.toString(),
      dueDate: json['dueDate']?.toString(),

      isActive: json['isActive'] as bool?,
      isFavourite: json['isFavourite'] as bool?,

      branchId: json['branchId'] as int?,

      createdDate: json['CreatedDate']?.toString(),
      createdUser: json['CreatedUser']?.toString(),

      modifiedDate: json['ModifedDate']?.toString(),
      modifiedUser: json['ModifedUser']?.toString(),

      files: json['files'] == null
          ? []
          : List<String>.from(
              (json['files'] as List).map((item) => item.toString()),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diaryId': diaryId,
      'AccYear': accYear,

      'StandardDivision': standardDivision
          ?.map((item) => (item as StandardDivisionModel).toJson())
          .toList(),

      'SubjectId': subjectId,
      'SubjectName': subjectName,

      'EmployeeId': employeeId,
      'employeeName': employeeName,

      'diaryType': diaryType,
      'DiaryType': diaryTypeName,

      'diaryTitle': diaryTitle,
      'Description': description,

      'diaryDate': diaryDate,
      'dueDate': dueDate,

      'isActive': isActive,
      'isFavourite': isFavourite,

      'branchId': branchId,

      'CreatedDate': createdDate,
      'CreatedUser': createdUser,

      'ModifedDate': modifiedDate,
      'ModifedUser': modifiedUser,

      'files': files,
    };
  }
}

class StandardDivisionModel extends StandardDivisionEntity {
  const StandardDivisionModel({
    super.standardId,
    super.standard,
    super.divisionId,
    super.division,
  });

  factory StandardDivisionModel.fromJson(Map<String, dynamic> json) {
    return StandardDivisionModel(
      standardId: json['StandardId'] as int?,
      standard: json['Standard']?.toString(),
      divisionId: json['DivisionId'] as int?,
      division: json['Division']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StandardId': standardId,
      'Standard': standard,
      'DivisionId': divisionId,
      'Division': division,
    };
  }
}
