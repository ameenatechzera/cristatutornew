class DiaryUpdateListingEntity {
  final int? status;
  final bool? error;
  final String? message;
  final DiaryUpdateListingData? data;

  const DiaryUpdateListingEntity({
    this.status,
    this.error,
    this.message,
    this.data,
  });
}

class DiaryUpdateListingData {
  final int? diaryId;
  final String? accYear;
  final List<DiaryStandardDivisionEntity>? standardDivision;
  // final int? standardId;
  // final int? divisionId;
  final int? subjectId;
  final int? employeeId;
  final int? diaryType;
  final String? diaryTitle;
  final String? description;
  final String? diaryDate;
  final String? dueDate;
  final bool? isActive;
  final bool? isFavourite;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final List<String>? files;
  final String? videoUrl;

  const DiaryUpdateListingData({
    this.diaryId,
    this.accYear,
    this.standardDivision,
    this.subjectId,
    this.employeeId,
    this.diaryType,
    this.diaryTitle,
    this.description,
    this.diaryDate,
    this.dueDate,
    this.isActive,
    this.isFavourite,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.files,
    this.videoUrl,
  });
}

class DiaryStandardDivisionEntity {
  final int standardId;
  final String? standard;
  final int divisionId;
  final String? division;

  const DiaryStandardDivisionEntity({
    required this.standardId,
    this.standard,
    required this.divisionId,
    this.division,
  });
}
