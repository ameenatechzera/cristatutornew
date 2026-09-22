import 'package:cristalteacher/core/errors/failure.dart';
import 'package:cristalteacher/features/materials/data/datasources/materials_remote_data_source.dart';
import 'package:cristalteacher/features/materials/domain/entities/material_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/repository/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/materials/domain/entities/fetch_material_entity.dart';
import 'package:cristalteacher/features/materials/domain/parameter/fetch_material_parameter.dart';
import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  final MaterialRemoteDataSource remoteDataSource;

  MaterialRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<FetchMaterialEntity> fetchMaterials(
    FetchMaterialParameter params,
  ) async {
    try {
      final result = await remoteDataSource.fetchMaterials(params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  ResultFuture<MasterResponseModel> saveMaterial(
    SaveMaterialParameter params,
  ) async {
    try {
      final result = await remoteDataSource.saveMaterial(params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  ResultFuture<MasterResponseModel> deleteMaterial(int id) async {
    try {
      final result = await remoteDataSource.deleteMaterial(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }

  @override
  ResultFuture<MaterialDetailsResponseEntity> fetchMaterialDetails(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.fetchMaterialDetails(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.statusMessage));
    }
  }
}
