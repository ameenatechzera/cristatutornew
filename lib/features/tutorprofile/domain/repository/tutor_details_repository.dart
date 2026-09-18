import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';

abstract class TutorDetailsRepository {
  ResultFuture<TutorDetailsEntity> fetchTutorDetails();
}
