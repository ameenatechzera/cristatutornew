import 'package:cristalteacher/features/exam/domain/entities/fetch_examtype_response_entity.dart';

class ExamTypeResponseModel extends ExamTypeResponseEntity {
  const ExamTypeResponseModel({super.status, super.error, super.data});

  factory ExamTypeResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];

    return ExamTypeResponseModel(
      status: _parseInt(json['status']),
      error: _parseBool(json['error']),
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map(
                  (item) =>
                      ExamTypeModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const <ExamTypeModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'data': data.map((item) {
        if (item is ExamTypeModel) {
          return item.toJson();
        }

        return ExamTypeModel.fromEntity(item).toJson();
      }).toList(),
    };
  }
}

class ExamTypeModel extends ExamTypeEntity {
  const ExamTypeModel({
    super.examTypeId,
    super.orderNo,
    super.examTypeName,
    super.weightage,
    super.status,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.isPublic,
    super.isOpen,
  });

  factory ExamTypeModel.fromJson(Map<String, dynamic> json) {
    return ExamTypeModel(
      examTypeId: _parseInt(json['ExamTypeId']),
      orderNo: _parseInt(json['OrderNo']),
      examTypeName: _parseString(json['ExamTypeName']),
      weightage: _parseDouble(json['Weightage']),
      status: _parseString(json['Status']),
      branchId: _parseInt(json['branchId']),
      createdDate: _parseDateTime(json['CreatedDate']),
      createdUser: _parseString(json['CreatedUser']),
      modifiedDate: _parseDateTime(json['ModifiedDate']),
      modifiedUser: _parseString(json['ModifiedUser']),
      isPublic: _parseBool(json['isPublic']),
      isOpen: _parseBool(json['isOpen']),
    );
  }

  factory ExamTypeModel.fromEntity(ExamTypeEntity entity) {
    return ExamTypeModel(
      examTypeId: entity.examTypeId,
      orderNo: entity.orderNo,
      examTypeName: entity.examTypeName,
      weightage: entity.weightage,
      status: entity.status,
      branchId: entity.branchId,
      createdDate: entity.createdDate,
      createdUser: entity.createdUser,
      modifiedDate: entity.modifiedDate,
      modifiedUser: entity.modifiedUser,
      isPublic: entity.isPublic,
      isOpen: entity.isOpen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ExamTypeId': examTypeId?.toString(),
      'OrderNo': orderNo?.toString(),
      'ExamTypeName': examTypeName,
      'Weightage': _formatNumber(weightage),
      'Status': status,
      'branchId': branchId,
      'CreatedDate': createdDate?.toIso8601String(),
      'CreatedUser': createdUser,
      'ModifiedDate': modifiedDate?.toIso8601String(),
      'ModifiedUser': modifiedUser,
      'isPublic': isPublic,
      'isOpen': isOpen,
    };
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();

  return int.tryParse(value.toString().trim());
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();

  return double.tryParse(value.toString().trim());
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;

  switch (value.toString().trim().toLowerCase()) {
    case 'true':
    case '1':
    case 'yes':
      return true;

    case 'false':
    case '0':
    case 'no':
      return false;

    default:
      return null;
  }
}

String? _parseString(dynamic value) {
  if (value == null) return null;

  final String result = value.toString().trim();
  return result.isEmpty ? null : result;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;

  final String result = value.toString().trim();
  if (result.isEmpty) return null;

  return DateTime.tryParse(result);
}

String? _formatNumber(double? value) {
  if (value == null) return null;

  if (value == value.truncateToDouble()) {
    return value.toInt().toString();
  }

  return value.toString();
}
