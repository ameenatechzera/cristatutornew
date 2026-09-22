import 'package:bloc/bloc.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/features/diary/domain/entities/diary_entity.dart';
import 'package:cristalteacher/features/diary/domain/entities/update_listing_entity.dart';
import 'package:cristalteacher/features/diary/domain/parameters/fetch_diary_parameter.dart';
import 'package:cristalteacher/features/diary/domain/parameters/save_diary_parameter.dart';
import 'package:cristalteacher/features/diary/domain/parameters/update_diary_parameter.dart';
import 'package:cristalteacher/features/diary/domain/usecases/delete_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/fetch_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/save_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/update_diary_usecase.dart';
import 'package:cristalteacher/features/diary/domain/usecases/updatelisting_usecase.dart';
import 'package:equatable/equatable.dart';

part 'diary_state.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final FetchDiaryUseCase _fetchDiaryUseCase;
  final SaveDiaryUseCase _saveDiaryUseCase;
  final DeleteDiaryUseCase _deleteDiaryUseCase;
  final FetchDiaryUpdateListingUseCase _fetchDiaryUpdateListingUseCase;
  final UpdateDiaryUseCase _updateDiaryUseCase;

  DiaryCubit({
    required FetchDiaryUseCase fetchDiaryUseCase,
    required SaveDiaryUseCase saveDiaryUseCase,
    required DeleteDiaryUseCase deleteDiaryUseCase,
    required FetchDiaryUpdateListingUseCase fetchDiaryUpdateListingUseCase,
    required UpdateDiaryUseCase updateDiaryUseCase,
  }) : _fetchDiaryUseCase = fetchDiaryUseCase,
       _saveDiaryUseCase = saveDiaryUseCase,
       _deleteDiaryUseCase = deleteDiaryUseCase,
       _fetchDiaryUpdateListingUseCase = fetchDiaryUpdateListingUseCase,
       _updateDiaryUseCase = updateDiaryUseCase,
       super(DiaryInitial());

  //   Future<void> fetchDiary(FetchDiaryParameter request) async {
  //     print('📘 Fetch Diary Request: ${request.toJson()}');

  //     emit(DiaryLoading());

  //     try {
  //       final result = await _fetchDiaryUseCase(request);

  //       result.fold(
  //         (failure) {
  //           print('❌ Fetch Diary Failed');
  //           print(failure.message);

  //           emit(DiaryFailure(failure.message));
  //         },
  //         (response) {
  //           emit(DiarySuccess(response));
  //         },
  //       );
  //     } catch (e, stackTrace) {
  //       print('❌ Exception during Fetch Diary');
  //       print(e);
  //       print(stackTrace);

  //       emit(const DiaryFailure('An unexpected error occurred'));
  //     }
  //   }
  // }
  Future<void> fetchDiary(FetchDiaryParameter request) async {
    print('📘 Fetch Diary Request: ${request.toJson()}');

    emit(DiaryLoading());

    try {
      final result = await _fetchDiaryUseCase(request);

      result.fold(
        (failure) {
          print('❌ Fetch Diary Failed');
          print(failure.message);

          emit(DiaryFailure(failure.message));
        },
        (response) {
          print('✅ Diary count: ${response.data?.length ?? 0}');

          emit(DiarySuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during Fetch Diary');
      print(e);
      print(stackTrace);

      emit(const DiaryFailure('An unexpected error occurred'));
    }
  }

  Future<void> saveDiary(SaveDiaryParameter request) async {
    //print('📘 Save Diary Request: ${request.toJson()}');

    emit(SaveDiaryLoading());

    try {
      final result = await _saveDiaryUseCase(request);

      result.fold(
        (failure) {
          print('❌ Save Diary Failed');
          print('Failure Message: ${failure.message}');

          emit(DiaryFailure(failure.message));
        },
        (response) {
          print('==========================================');
          print('✅ SAVE DIARY SUCCESS');
          print('==========================================');
          print('📌 Status  : ${response.status}');
          print('📌 Error   : ${response.error}');
          print('📌 Message : ${response.message}');
          print('==========================================');

          emit(SaveDiarySuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('==========================================');
      print('❌ EXCEPTION DURING SAVE DIARY');
      print('==========================================');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      print('==========================================');

      emit(const DiaryFailure('An unexpected error occurred'));
    }
  } // ============================================================
  // DELETE DIARY
  // ============================================================

  Future<void> deleteDiary(int diaryId) async {
    print('');
    print('==========================================');
    print('🗑️ DELETE DIARY');
    print('==========================================');
    print('Diary ID: $diaryId');

    emit(DeleteDiaryLoading());

    try {
      final result = await _deleteDiaryUseCase(diaryId);

      result.fold(
        (failure) {
          print('❌ Delete Diary Failed');
          print(failure.message);

          emit(DiaryFailure(failure.message));
        },
        (response) {
          print('✅ Delete Diary Success');
          print('Status: ${response.status}');
          print('Message: ${response.error}');

          emit(DeleteDiarySuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception during Delete Diary');
      print(e);
      print(stackTrace);

      emit(
        const DiaryFailure('An unexpected error occurred while deleting diary'),
      );
    }
  }

  Future<void> fetchDiaryUpdateListing(int diaryId) async {
    print('');
    print('==========================================');
    print('📘 FETCH DIARY UPDATE LISTING');
    print('==========================================');
    print('Diary ID: $diaryId');

    if (diaryId <= 0) {
      emit(const FetchDiaryUpdateListingFailure('Invalid diary ID'));
      return;
    }

    emit(FetchDiaryUpdateListingLoading());

    try {
      final result = await _fetchDiaryUpdateListingUseCase(diaryId);

      result.fold(
        (failure) {
          print('❌ Fetch Diary Update Listing Failed');
          print('Message: ${failure.message}');

          emit(FetchDiaryUpdateListingFailure(failure.message));
        },
        (response) {
          print('==========================================');
          print('✅ FETCH DIARY UPDATE LISTING SUCCESS');
          print('==========================================');
          print('Status       : ${response.status}');
          print('Error        : ${response.error}');
          print('Message      : ${response.message}');
          print('Diary ID     : ${response.data?.diaryId}');
          print('Standard ID  : ${response.data?.standardId}');
          print('Division ID  : ${response.data?.divisionId}');
          print('Subject ID   : ${response.data?.subjectId}');
          print('Diary Title  : ${response.data?.diaryTitle}');
          print('Files        : ${response.data?.files?.length ?? 0}');
          print('==========================================');

          emit(FetchDiaryUpdateListingSuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('==========================================');
      print('❌ FETCH DIARY UPDATE LISTING EXCEPTION');
      print('==========================================');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      print('==========================================');

      emit(
        const FetchDiaryUpdateListingFailure(
          'An unexpected error occurred while fetching diary details',
        ),
      );
    }
  }

  Future<void> updateDiary(UpdateDiaryParameter request, int diaryId) async {
    print('');
    print('==========================================');
    print('🟠 UPDATE DIARY');
    print('==========================================');
    print('Diary ID: $diaryId');
    print('Request : ${request.toJson()}');

    if (diaryId <= 0) {
      emit(const UpdateDiaryFailure('Invalid diary ID'));
      return;
    }

    emit(UpdateDiaryLoading());

    try {
      final result = await _updateDiaryUseCase(request, diaryId);

      result.fold(
        (failure) {
          print('==========================================');
          print('❌ UPDATE DIARY FAILED');
          print('==========================================');
          print('Message: ${failure.message}');
          print('==========================================');

          emit(UpdateDiaryFailure(failure.message));
        },
        (response) {
          print('==========================================');
          print('✅ UPDATE DIARY SUCCESS');
          print('==========================================');
          print('Status  : ${response.status}');
          print('Error   : ${response.error}');
          print('Message : ${response.message}');
          print('==========================================');

          emit(UpdateDiarySuccess(response));
        },
      );
    } catch (e, stackTrace) {
      print('==========================================');
      print('❌ EXCEPTION DURING UPDATE DIARY');
      print('==========================================');
      print('Error      : $e');
      print('StackTrace : $stackTrace');
      print('==========================================');

      emit(
        const UpdateDiaryFailure(
          'An unexpected error occurred while updating diary',
        ),
      );
    }
  }
}
