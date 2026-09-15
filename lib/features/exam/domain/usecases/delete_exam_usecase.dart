import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';

class DeleteExamUseCase implements UseCaseWithParams<MasterResponseModel, int> {
  final ExamManagementRepository _examManagementRepository;

  DeleteExamUseCase(this._examManagementRepository);

  @override
  ResultFuture<MasterResponseModel> call(int examId) async {
    return _examManagementRepository.deleteExam(examId);
  }
}
