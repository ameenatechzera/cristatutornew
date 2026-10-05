import 'package:cristalteacher/features/materials/domain/parameter/update_material_parameter.dart';
import 'package:cristalteacher/features/materials/domain/repository/material_repository.dart';

class UpdateMaterialUseCase {
  final MaterialRepository repository;

  const UpdateMaterialUseCase(this.repository);

  // Preserves the repository's return type and error handling.
  call(int materialId, UpdateMaterialParameter params) {
    return repository.updateMaterial(materialId, params);
  }
}
