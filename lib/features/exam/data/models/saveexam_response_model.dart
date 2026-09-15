import 'package:cristalteacher/features/exam/domain/entities/saveexam_response_entity.dart';

class SaveExamResponseModel extends SaveExamResponseEntity {
  const SaveExamResponseModel({
    super.status,
    super.error,
    super.message,
    super.examId,
  });

  factory SaveExamResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveExamResponseModel(
      status: _toInt(json['status']),
      error: _toBool(json['error']),
      message: json['message']?.toString(),
      examId: _toInt(json['examId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'examId': examId,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString());
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;

    final String normalized = value.toString().trim().toLowerCase();

    if (normalized == 'true' || normalized == '1') {
      return true;
    }

    if (normalized == 'false' || normalized == '0') {
      return false;
    }

    return null;
  }
}
