import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:cristalteacher/features/feed/domain/entities/feed_updatelisting_entity.dart';
import 'package:cristalteacher/features/feed/domain/parameters/fetch_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/parameters/update_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/repository/feed_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:cristalteacher/core/errors/failure.dart';
import 'package:cristalteacher/features/feed/domain/entities/fetch_feed_entity.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, FetchFeedEntity>> fetchFeed(
    FetchFeedParams params,
  ) async {
    try {
      final response = await remoteDataSource.fetchFeed(params);

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Something went wrong"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> saveFeed(SaveFeedParameter request) async {
    try {
      final response = await remoteDataSource.saveFeed(request);

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Something went wrong"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> deleteFeed(int id) async {
    try {
      final response = await remoteDataSource.deleteFeed(id);

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Something went wrong"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<FeedUpdateListingEntity> feedUpdateListing(int feedId) async {
    try {
      final response = await remoteDataSource.feedUpdateListing(feedId);

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Something went wrong"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<MasterResponseModel> updateFeed(
    UpdateFeedParameter params,
    int feedId,
  ) async {
    try {
      final response = await remoteDataSource.updateFeed(feedId, params);

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Something went wrong"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
