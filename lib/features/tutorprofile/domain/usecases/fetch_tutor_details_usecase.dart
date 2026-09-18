import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';
import 'package:cristalteacher/features/tutorprofile/domain/repository/tutor_details_repository.dart';

class FetchTutorDetailsUseCase
    implements UseCaseWithoutParams<TutorDetailsEntity> {
  final TutorDetailsRepository _tutorDetailsRepository;

  FetchTutorDetailsUseCase(this._tutorDetailsRepository);

  @override
  ResultFuture<TutorDetailsEntity> call() {
    return _tutorDetailsRepository.fetchTutorDetails();
  }
}
