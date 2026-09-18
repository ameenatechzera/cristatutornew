import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/errors/failure.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/tutorprofile/data/datasources/tutor_details_remote_datasource.dart';
import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';
import 'package:cristalteacher/features/tutorprofile/domain/repository/tutor_details_repository.dart';
import 'package:dartz/dartz.dart';

class TutorDetailsRepositoryImpl implements TutorDetailsRepository {
  final TutorDetailsRemoteDataSource _remoteDataSource;

  TutorDetailsRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<TutorDetailsEntity> fetchTutorDetails() async {
    try {
      final result = await _remoteDataSource.fetchTutorDetails();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessageModel.statusMessage));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
