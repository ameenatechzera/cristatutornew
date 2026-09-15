class SaveExamResponseEntity {
  final int? status;
  final bool? error;
  final String? message;
  final int? examId;

  const SaveExamResponseEntity({
    this.status,
    this.error,
    this.message,
    this.examId,
  });
}
