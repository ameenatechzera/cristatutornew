import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/errors/failure.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/exam/data/datasources/exam_management_remote_data_source.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examterm_entity.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examtype_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/entities/saveexam_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
import 'package:cristalteacher/features/exam/domain/repositories/exam_management_repository.dart';
import 'package:dartz/dartz.dart';

class ExamManagementRepositoryImpl implements ExamManagementRepository {
  final ExamManagementRemoteDataSource remoteDataSource;

  const ExamManagementRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<ExamListingResponseEntity> fetchExamListing() async {
    try {
      final result = await remoteDataSource.fetchExamListing();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  ResultFuture<ExamTypeResponseEntity> getExamTypes() async {
    try {
      final result = await remoteDataSource.getExamTypes();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  ResultFuture<ExamTermResponseEntity> getExamTerms() async {
    try {
      final result = await remoteDataSource.getExamTerms();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  ResultFuture<SaveExamResponseEntity> saveExam(
    SaveExamParameter parameter,
  ) async {
    try {
      final result = await remoteDataSource.saveExam(parameter);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> deleteExam(int examId) async {
    try {
      final result = await remoteDataSource.deleteExam(examId);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  ResultFuture<ExamListingResponseEntity> updateExam(
    int examId,
    SaveExamParameter params,
  ) async {
    try {
      final result = await remoteDataSource.updateExam(examId, params);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
