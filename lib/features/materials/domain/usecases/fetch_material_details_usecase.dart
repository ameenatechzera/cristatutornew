import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/materials/domain/entities/material_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/repository/material_repository.dart';

class FetchMaterialDetailsUseCase
    implements UseCaseWithParams<MaterialDetailsResponseEntity, int> {
  final MaterialRepository _materialRepository;

  FetchMaterialDetailsUseCase(this._materialRepository);

  @override
  ResultFuture<MaterialDetailsResponseEntity> call(int materialId) async {
    return _materialRepository.fetchMaterialDetails(materialId);
  }
}
