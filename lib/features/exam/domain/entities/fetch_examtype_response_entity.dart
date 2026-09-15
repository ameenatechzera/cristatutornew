class ExamTypeResponseEntity {
  final int? status;
  final bool? error;
  final List<ExamTypeEntity> data;

  const ExamTypeResponseEntity({this.status, this.error, this.data = const []});
}

class ExamTypeEntity {
  final int? examTypeId;
  final int? orderNo;
  final String? examTypeName;
  final double? weightage;
  final String? status;
  final int? branchId;
  final DateTime? createdDate;
  final String? createdUser;
  final DateTime? modifiedDate;
  final String? modifiedUser;
  final bool? isPublic;
  final bool? isOpen;

  const ExamTypeEntity({
    this.examTypeId,
    this.orderNo,
    this.examTypeName,
    this.weightage,
    this.status,
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.isPublic,
    this.isOpen,
  });

  bool get isActive => status?.toLowerCase() == 'active';
}
