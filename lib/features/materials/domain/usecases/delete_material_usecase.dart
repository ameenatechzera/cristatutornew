import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/materials/domain/repository/material_repository.dart';

class DeleteMaterialUseCase
    implements UseCaseWithParams<MasterResponseModel, int> {
  final MaterialRepository _materialRepository;

  DeleteMaterialUseCase(this._materialRepository);

  @override
  ResultFuture<MasterResponseModel> call(int id) async {
    return _materialRepository.deleteMaterial(id);
  }
}
