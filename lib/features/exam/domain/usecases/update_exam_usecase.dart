import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';

class UpdateExamUseCase {
  final ExamManagementRepository _examManagementRepository;

  UpdateExamUseCase(this._examManagementRepository);

  ResultFuture<ExamListingResponseEntity> call(
    int examId,
    SaveExamParameter params,
  ) async {
    return _examManagementRepository.updateExam(examId, params);
  }
}
