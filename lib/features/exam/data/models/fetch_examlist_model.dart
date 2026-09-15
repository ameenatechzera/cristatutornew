import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';

class ExamListingResponseModel extends ExamListingResponseEntity {
  const ExamListingResponseModel({
    super.status,
    super.error,
    List<ExamListingModel>? super.data,
  });

  factory ExamListingResponseModel.fromJson(Map<String, dynamic> json) {
    return ExamListingResponseModel(
      status: json['status'] as int?,
      error: json['error'] as bool?,
      data: (json['data'] as List?)
          ?.map(
            (item) => ExamListingModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class ExamListingModel extends ExamListingEntity {
  const ExamListingModel({
    super.examId,
    super.examName,
    super.examTermId,
    super.examTermName,
    super.examTypeId,
    super.examTypeName,
    super.isOpen,
    super.isPublish,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.branchId,
  });

  factory ExamListingModel.fromJson(Map<String, dynamic> json) {
    return ExamListingModel(
      examId: json['examId'] as int?,
      examName: json['examName']?.toString(),
      examTermId: json['examTermId'] as int?,
      examTermName: json['ExamTermName']?.toString(),
      examTypeId: json['examTypeId'] as int?,
      examTypeName: json['ExamTypeName']?.toString(),
      isOpen: json['isOpen'] as bool?,
      isPublish: json['isPublish'] as bool?,
      createdDate: json['CreatedDate']?.toString(),
      createdUser: json['CreatedUser']?.toString(),
      modifiedDate: json['ModifiedDate']?.toString(),
      modifiedUser: json['ModifiedUser']?.toString(),
      branchId: json['branchId'] as int?,
    );
  }
}
