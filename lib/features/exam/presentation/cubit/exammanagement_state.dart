part of 'exammanagement_cubit.dart';

sealed class ExamManagementState extends Equatable {
  const ExamManagementState();

  @override
  List<Object?> get props => [];
}

final class ExamManagementInitial extends ExamManagementState {
  const ExamManagementInitial();
}

final class ExamListingLoading extends ExamManagementState {
  const ExamListingLoading();
}

final class ExamListingSuccess extends ExamManagementState {
  final ExamListingResponseEntity response;

  const ExamListingSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ExamListingFailure extends ExamManagementState {
  final String message;

  const ExamListingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Exam type states

final class ExamTypesLoading extends ExamManagementState {
  const ExamTypesLoading();
}

final class ExamTypesSuccess extends ExamManagementState {
  final ExamTypeResponseEntity response;

  const ExamTypesSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ExamTypesFailure extends ExamManagementState {
  final String message;

  const ExamTypesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class ExamTermsLoading extends ExamManagementState {
  const ExamTermsLoading();
}

final class ExamTermsSuccess extends ExamManagementState {
  final ExamTermResponseEntity response;

  const ExamTermsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ExamTermsFailure extends ExamManagementState {
  final String message;

  const ExamTermsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class SaveExamLoading extends ExamManagementState {
  const SaveExamLoading();
}

final class SaveExamSuccess extends ExamManagementState {
  final SaveExamResponseEntity response;

  const SaveExamSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class SaveExamFailure extends ExamManagementState {
  final String message;

  const SaveExamFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class DeleteExamLoading extends ExamManagementState {
  final int examId;

  const DeleteExamLoading(this.examId);

  @override
  List<Object?> get props => [examId];
}

final class DeleteExamSuccess extends ExamManagementState {
  final MasterResponseModel response;
  final int examId;

  const DeleteExamSuccess({required this.response, required this.examId});

  @override
  List<Object?> get props => [response, examId];
}

final class DeleteExamFailure extends ExamManagementState {
  final String message;

  const DeleteExamFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateExamLoading extends ExamManagementState {
  final int examId;

  const UpdateExamLoading(this.examId);

  @override
  List<Object?> get props => [examId];
}

class UpdateExamSuccess extends ExamManagementState {
  final ExamListingResponseEntity response;
  final int examId;

  const UpdateExamSuccess({required this.response, required this.examId});

  @override
  List<Object?> get props => [response, examId];
}

class UpdateExamFailure extends ExamManagementState {
  final String message;

  const UpdateExamFailure(this.message);

  @override
  List<Object?> get props => [message];
}
