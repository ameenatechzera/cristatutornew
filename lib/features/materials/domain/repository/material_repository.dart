import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/materials/domain/entities/fetch_material_entity.dart';
import 'package:cristalteacher/features/materials/domain/entities/material_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/parameter/fetch_material_parameter.dart';
import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';

abstract class MaterialRepository {
  ResultFuture<FetchMaterialEntity> fetchMaterials(
    FetchMaterialParameter params,
  );
  ResultFuture<MasterResponseModel> saveMaterial(SaveMaterialParameter params);
  ResultFuture<MasterResponseModel> deleteMaterial(int id);
  ResultFuture<MaterialDetailsResponseEntity> fetchMaterialDetails(int id);
}
