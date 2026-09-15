import 'package:bloc/bloc.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examlist_entities.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examterm_entity.dart';
import 'package:cristalteacher/features/exam/domain/entities/fetch_examtype_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/entities/saveexam_response_entity.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
import 'package:cristalteacher/features/exam/domain/usecases/delete_exam_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/fetch_examlist_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/fetch_examterm_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/fetch_examtype_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/saveexam_usecase.dart';
import 'package:cristalteacher/features/exam/domain/usecases/update_exam_usecase.dart';
import 'package:equatable/equatable.dart';

part 'exammanagement_state.dart';

class ExamManagementCubit extends Cubit<ExamManagementState> {
  final FetchExamListingUseCase _fetchExamListingUseCase;
  final GetExamTypesUseCase _getExamTypesUseCase;
  final GetExamTermsUseCase _getExamTermsUseCase;
  final SaveExamUseCase _saveExamUseCase;
  final DeleteExamUseCase _deleteExamUseCase;
  final UpdateExamUseCase _updateExamUseCase;

  ExamManagementCubit({
    required FetchExamListingUseCase fetchExamListingUseCase,
    required GetExamTypesUseCase getExamTypesUseCase,
    required GetExamTermsUseCase getExamTermsUseCase,
    required SaveExamUseCase saveExamUseCase,
    required DeleteExamUseCase deleteExamUseCase,
    required UpdateExamUseCase updateExamUseCase,
  }) : _fetchExamListingUseCase = fetchExamListingUseCase,
       _getExamTypesUseCase = getExamTypesUseCase,
       _getExamTermsUseCase = getExamTermsUseCase,
       _saveExamUseCase = saveExamUseCase,
       _deleteExamUseCase = deleteExamUseCase,
       _updateExamUseCase = updateExamUseCase,
       super(const ExamManagementInitial());

  Future<void> fetchExamListing() async {
    print('');
    print('==========================================');
    print('📘 FETCH EXAM LISTING CALLED');
    print('==========================================');

    emit(const ExamListingLoading());

    try {
      final result = await _fetchExamListingUseCase();

      result.fold(
        (failure) {
          print('❌ Fetch Exam Listing Failed');
          print('Failure Message: ${failure.message}');

          emit(ExamListingFailure(failure.message));
        },
        (response) {
          print('✅ Fetch Exam Listing Success');
          print('Total Exams: ${response.data?.length ?? 0}');

          emit(ExamListingSuccess(response));
        },
      );
    } catch (error, stackTrace) {
      print('❌ Exception during fetchExamListing: $error');
      print('Stacktrace: $stackTrace');

      emit(const ExamListingFailure('An unexpected error occurred'));
    }
  }

  Future<void> getExamTypes() async {
    emit(const ExamTypesLoading());

    try {
      final result = await _getExamTypesUseCase();

      result.fold(
        (failure) {
          emit(ExamTypesFailure(failure.message));
        },
        (response) {
          emit(ExamTypesSuccess(response));
        },
      );
    } catch (_) {
      emit(const ExamTypesFailure('An unexpected error occurred'));
    }
  }

  Future<void> getExamTerms() async {
    emit(const ExamTermsLoading());

    try {
      final result = await _getExamTermsUseCase();

      result.fold(
        (failure) {
          emit(ExamTermsFailure(failure.message));
        },
        (response) {
          emit(ExamTermsSuccess(response));
        },
      );
    } catch (_) {
      emit(const ExamTermsFailure('An unexpected error occurred'));
    }
  }

  Future<void> saveExam(SaveExamParameter parameter) async {
    emit(const SaveExamLoading());

    try {
      final result = await _saveExamUseCase(parameter);

      result.fold(
        (failure) {
          emit(SaveExamFailure(failure.message));
        },
        (response) {
          emit(SaveExamSuccess(response));
        },
      );
    } catch (_) {
      emit(const SaveExamFailure('An unexpected error occurred'));
    }
  }

  Future<void> deleteExam(int examId) async {
    if (examId <= 0) {
      emit(const DeleteExamFailure('Invalid Exam ID'));
      return;
    }

    emit(DeleteExamLoading(examId));

    try {
      final result = await _deleteExamUseCase(examId);

      result.fold(
        (failure) {
          emit(DeleteExamFailure(failure.message));
        },
        (response) {
          emit(DeleteExamSuccess(response: response, examId: examId));
        },
      );
    } catch (_) {
      emit(const DeleteExamFailure('An unexpected error occurred'));
    }
  }

  Future<void> updateExam(int examId, SaveExamParameter parameter) async {
    if (examId <= 0) {
      emit(const UpdateExamFailure('Invalid Exam ID'));
      return;
    }

    emit(UpdateExamLoading(examId));

    try {
      final result = await _updateExamUseCase(examId, parameter);

      result.fold(
        (failure) {
          emit(UpdateExamFailure(failure.message));
        },
        (response) {
          emit(UpdateExamSuccess(response: response, examId: examId));
        },
      );
    } catch (_) {
      emit(const UpdateExamFailure('An unexpected error occurred'));
    }
  }
}
