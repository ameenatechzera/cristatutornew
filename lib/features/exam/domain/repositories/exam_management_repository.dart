import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examterm_entity.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examtype_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/entities/saveexam_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';

abstract class ExamManagementRepository {
  ResultFuture<ExamListingResponseEntity> fetchExamListing();
  ResultFuture<ExamTypeResponseEntity> getExamTypes();
  ResultFuture<ExamTermResponseEntity> getExamTerms();
  ResultFuture<SaveExamResponseEntity> saveExam(SaveExamParameter parameter);
  ResultFuture<MasterResponseModel> deleteExam(int examId);
  ResultFuture<ExamListingResponseEntity> updateExam(
    int examId,
    SaveExamParameter params,
  );
}
