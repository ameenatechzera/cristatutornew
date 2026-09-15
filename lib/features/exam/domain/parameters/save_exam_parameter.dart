class SaveExamParameter {
  final String examName;
  final int examTermId;
  final int examTypeId;
  final bool isOpen;
  final bool isPublish;
  final int branchId;
  final int createdUser;

  const SaveExamParameter({
    required this.examName,
    required this.examTermId,
    required this.examTypeId,
    required this.isOpen,
    required this.isPublish,
    required this.branchId,
    required this.createdUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'examName': examName,
      'examTermId': examTermId,
      'examTypeId': examTypeId,
      'isOpen': isOpen,
      'isPublish': isPublish,
      'branchId': branchId,
      'CreatedUser': createdUser,
    };
  }
}
