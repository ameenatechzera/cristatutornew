import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/entities/saveexam_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';

class SaveExamUseCase
    implements UseCaseWithParams<SaveExamResponseEntity, SaveExamParameter> {
  final ExamManagementRepository _examManagementRepository;

  SaveExamUseCase(this._examManagementRepository);

  @override
  ResultFuture<SaveExamResponseEntity> call(SaveExamParameter params) async {
    return _examManagementRepository.saveExam(params);
  }
}
