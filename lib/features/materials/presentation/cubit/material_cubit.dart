import 'package:bloc/bloc.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/features/materials/domain/entities/fetch_material_entity.dart';
import 'package:cristalteacher/features/materials/domain/entities/material_details_entity.dart';
import 'package:cristalteacher/features/materials/domain/parameter/fetch_material_parameter.dart';
import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
import 'package:cristalteacher/features/materials/domain/usecases/delete_material_usecase.dart';
import 'package:cristalteacher/features/materials/domain/usecases/fetch_material_details_usecase.dart';
import 'package:cristalteacher/features/materials/domain/usecases/fetch_material_usecase.dart';
import 'package:cristalteacher/features/materials/domain/usecases/save_material_usecase.dart';
import 'package:equatable/equatable.dart';

part 'material_state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  final FetchMaterialUseCase _fetchMaterialUseCase;
  final SaveMaterialUseCase _saveMaterialUseCase;
  final DeleteMaterialUseCase _deleteMaterialUseCase;
  final FetchMaterialDetailsUseCase _fetchMaterialDetailsUseCase;

  MaterialCubit({
    required FetchMaterialUseCase fetchMaterialUseCase,
    required SaveMaterialUseCase saveMaterialUseCase,
    required FetchMaterialDetailsUseCase fetchMaterialDetailsUseCase,
    required DeleteMaterialUseCase deleteMaterialUseCase,
  }) : _fetchMaterialUseCase = fetchMaterialUseCase,
       _fetchMaterialDetailsUseCase = fetchMaterialDetailsUseCase,
       _saveMaterialUseCase = saveMaterialUseCase,
       _deleteMaterialUseCase = deleteMaterialUseCase,
       super(MaterialInitial());

  Future<void> fetchMaterials(FetchMaterialParameter request) async {
    print('📘 Fetch Materials Request: ${request.toJson()}');

    emit(FetchMaterialLoading());

    try {
      final result = await _fetchMaterialUseCase(request);

      result.fold(
        (failure) {
          print('❌ Fetch Materials Failed');
          print(failure.message);

          emit(FetchMaterialFailure(failure.message));
        },
        (response) {
          emit(FetchMaterialSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during fetchMaterials');
      print(e);
      print(stackTrace);

      emit(const FetchMaterialFailure('An unexpected error occurred'));
    }
  }

  Future<void> saveMaterial(SaveMaterialParameter request) async {
    print('📘 Save Material Request');

    emit(SaveMaterialLoading());

    try {
      final result = await _saveMaterialUseCase(request);

      result.fold(
        (failure) {
          print('❌ Save Material Failed');
          print(failure.message);

          emit(SaveMaterialFailure(failure.message));
        },
        (response) {
          emit(SaveMaterialSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during saveMaterial');
      print(e);
      print(stackTrace);

      emit(const SaveMaterialFailure('An unexpected error occurred'));
    }
  }

  Future<void> deleteMaterial(int id) async {
    emit(DeleteMaterialLoading());

    try {
      final result = await _deleteMaterialUseCase(id);

      result.fold(
        (failure) {
          emit(DeleteMaterialFailure(failure.message));
        },
        (response) {
          emit(DeleteMaterialSuccess(response));
        },
      );
    } catch (e) {
      emit(const DeleteMaterialFailure('An unexpected error occurred'));
    }
  }

  Future<void> fetchMaterialDetails(int materialId) async {
    print('📘 Fetch Material Details Request');
    print('Material ID: $materialId');

    emit(FetchMaterialDetailsLoading());

    try {
      final result = await _fetchMaterialDetailsUseCase(materialId);

      result.fold(
        (failure) {
          print('❌ Fetch Material Details Failed');
          print(failure.message);

          emit(FetchMaterialDetailsFailure(failure.message));
        },
        (response) {
          print('✅ Fetch Material Details Success');
          print('Material ID: ${response.data?.materialId}');

          emit(FetchMaterialDetailsSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during fetchMaterialDetails');
      print(e);
      print(stackTrace);

      emit(const FetchMaterialDetailsFailure('An unexpected error occurred'));
    }
  }
}
