import 'package:cristalteacher/features/exam/domain/entities/fetch_examterm_entity.dart';

class ExamTermResponseModel extends ExamTermResponseEntity {
  const ExamTermResponseModel({super.status, super.error, super.data});

  factory ExamTermResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];

    return ExamTermResponseModel(
      status: _toInt(json['status']),
      error: _toBool(json['error']),
      data: rawData is List
          ? rawData.map((item) {
              return ExamTermModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              );
            }).toList()
          : <ExamTermModel>[],
    );
  }
}

class ExamTermModel extends ExamTermEntity {
  const ExamTermModel({
    super.examTermId,
    super.examTermName,
    super.status,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.isPublic,
  });

  factory ExamTermModel.fromJson(Map<String, dynamic> json) {
    return ExamTermModel(
      examTermId: _toInt(json['ExamTermId']),
      examTermName: _toStringValue(json['ExamTermName']),
      status: _toBool(json['Status']),
      branchId: _toInt(json['branchId']),
      createdDate: _toStringValue(json['CreatedDate']),
      createdUser: _toStringValue(json['CreatedUser']),
      modifiedDate: _toStringValue(json['ModifiedDate']),
      modifiedUser: _toStringValue(json['ModifiedUser']),
      isPublic: _toBool(json['isPublic']),
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) return value;

  if (value is num) {
    return value != 0;
  }

  final String normalizedValue = value.toString().trim().toLowerCase();

  if (normalizedValue == 'true' || normalizedValue == '1') {
    return true;
  }

  if (normalizedValue == 'false' || normalizedValue == '0') {
    return false;
  }

  return null;
}

String? _toStringValue(dynamic value) {
  if (value == null) return null;

  final String result = value.toString().trim();

  return result.isEmpty ? null : result;
}
