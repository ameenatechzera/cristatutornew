class ExamTermResponseEntity {
  final int? status;
  final bool? error;
  final List<ExamTermEntity>? data;

  const ExamTermResponseEntity({this.status, this.error, this.data});
}

class ExamTermEntity {
  final int? examTermId;
  final String? examTermName;
  final bool? status;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final bool? isPublic;

  const ExamTermEntity({
    this.examTermId,
    this.examTermName,
    this.status,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.isPublic,
  });
}
