import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';

class FetchExamListingUseCase
    implements UseCaseWithoutParams<ExamListingResponseEntity> {
  final ExamManagementRepository _examManagementRepository;

  FetchExamListingUseCase(this._examManagementRepository);

  @override
  ResultFuture<ExamListingResponseEntity> call() async {
    return _examManagementRepository.fetchExamListing();
  }
}
