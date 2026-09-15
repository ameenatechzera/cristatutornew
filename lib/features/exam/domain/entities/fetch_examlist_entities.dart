class ExamListingResponseEntity {
  final int? status;
  final bool? error;
  final List<ExamListingEntity>? data;

  const ExamListingResponseEntity({this.status, this.error, this.data});
}

class ExamListingEntity {
  final int? examId;
  final String? examName;
  final int? examTermId;
  final String? examTermName;
  final int? examTypeId;
  final String? examTypeName;
  final bool? isOpen;
  final bool? isPublish;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final int? branchId;

  const ExamListingEntity({
    this.examId,
    this.examName,
    this.examTermId,
    this.examTermName,
    this.examTypeId,
    this.examTypeName,
    this.isOpen,
    this.isPublish,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.branchId,
  });
}
