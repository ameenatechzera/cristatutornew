import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examterm_entity.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';

class GetExamTermsUseCase
    implements UseCaseWithoutParams<ExamTermResponseEntity> {
  final ExamManagementRepository _examManagementRepository;

  GetExamTermsUseCase(this._examManagementRepository);

  @override
  ResultFuture<ExamTermResponseEntity> call() async {
    return _examManagementRepository.getExamTerms();
  }
}
