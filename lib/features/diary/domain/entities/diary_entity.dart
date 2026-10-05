// import 'package:equatable/equatable.dart';

// class DiaryResponseEntity extends Equatable {
//   final int? status;
//   final bool? error;
//   final List<DiaryEntity>? data;

//   const DiaryResponseEntity({this.status, this.error, this.data});

//   @override
//   List<Object?> get props => [status, error, data];
// }

// class DiaryEntity extends Equatable {
//   final int diaryId;
//   final String? accYear;
//   final int? standardId;
//   final String? standard;
//   final int? divisionId;
//   final String? division;
//   final int? subjectId;
//   final String? subjectName;
//   final int? employeeId;
//   final String? employeeName;
//   final int? diaryType;
//   final String? diaryTypeName;
//   final String? diaryTitle;
//   final String? description;
//   final String? diaryDate;
//   final String? dueDate;
//   final bool? isActive;
//   final bool? isFavourite;
//   final int? branchId;
//   final String? createdDate;
//   final String? createdUser;
//   final String? modifiedDate;
//   final String? modifiedUser;
//   final List<String>? files;

//   const DiaryEntity({
//     required this.diaryId,
//     this.accYear,
//     this.standardId,
//     this.standard,
//     this.divisionId,
//     this.division,
//     this.subjectId,
//     this.subjectName,
//     this.employeeId,
//     this.employeeName,
//     this.diaryType,
//     this.diaryTypeName,
//     this.diaryTitle,
//     this.description,
//     this.diaryDate,
//     this.dueDate,
//     this.isActive,
//     this.isFavourite,
//     this.branchId,
//     this.createdDate,
//     this.createdUser,
//     this.modifiedDate,
//     this.modifiedUser,
//     this.files,
//   });

//   @override
//   List<Object?> get props => [
//     diaryId,
//     accYear,
//     standardId,
//     standard,
//     divisionId,
//     division,
//     subjectId,
//     subjectName,
//     employeeId,
//     employeeName,
//     diaryType,
//     diaryTypeName,
//     diaryTitle,
//     description,
//     diaryDate,
//     dueDate,
//     isActive,
//     isFavourite,
//     branchId,
//     createdDate,
//     createdUser,
//     modifiedDate,
//     modifiedUser,
//     files,
//   ];
// }
import 'package:equatable/equatable.dart';

class DiaryResponseEntity extends Equatable {
  final int? status;
  final bool? error;
  final List<DiaryEntity>? data;

  const DiaryResponseEntity({this.status, this.error, this.data});

  @override
  List<Object?> get props => [status, error, data];
}

class DiaryEntity extends Equatable {
  final int diaryId;
  final String? accYear;
  final List<StandardDivisionEntity>? standardDivision;
  final int? subjectId;
  final String? subjectName;
  final int? employeeId;
  final String? employeeName;
  final int? diaryType;
  final String? diaryTypeName;
  final String? diaryTitle;
  final String? description;
  final String? diaryDate;
  final String? dueDate;
  final bool? isActive;
  final bool? isFavourite;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final List<String>? files;

  const DiaryEntity({
    required this.diaryId,
    this.accYear,
    this.standardDivision,
    this.subjectId,
    this.subjectName,
    this.employeeId,
    this.employeeName,
    this.diaryType,
    this.diaryTypeName,
    this.diaryTitle,
    this.description,
    this.diaryDate,
    this.dueDate,
    this.isActive,
    this.isFavourite,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.files,
  });

  @override
  List<Object?> get props => [
    diaryId,
    accYear,
    standardDivision,
    subjectId,
    subjectName,
    employeeId,
    employeeName,
    diaryType,
    diaryTypeName,
    diaryTitle,
    description,
    diaryDate,
    dueDate,
    isActive,
    isFavourite,
    branchId,
    createdDate,
    createdUser,
    modifiedDate,
    modifiedUser,
    files,
  ];
}

class StandardDivisionEntity extends Equatable {
  final int? standardId;
  final String? standard;
  final int? divisionId;
  final String? division;

  const StandardDivisionEntity({
    this.standardId,
    this.standard,
    this.divisionId,
    this.division,
  });

  @override
  List<Object?> get props => [standardId, standard, divisionId, division];
}
