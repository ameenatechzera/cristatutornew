import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examtype_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';

class GetExamTypesUseCase
    implements UseCaseWithoutParams<ExamTypeResponseEntity> {
  final ExamManagementRepository _examManagementRepository;

  GetExamTypesUseCase(this._examManagementRepository);

  @override
  ResultFuture<ExamTypeResponseEntity> call() async {
    return _examManagementRepository.getExamTypes();
  }
}
