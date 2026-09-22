import '../../domain/entities/material_details_entity.dart';

class MaterialDetailsResponseModel extends MaterialDetailsResponseEntity {
  const MaterialDetailsResponseModel({super.status, super.error, super.data});

  factory MaterialDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];

    return MaterialDetailsResponseModel(
      status: _toInt(json['status']),
      error: _toBool(json['error']),
      data: rawData is Map
          ? MaterialDetailsModel.fromJson(Map<String, dynamic>.from(rawData))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'data': data is MaterialDetailsModel
          ? (data as MaterialDetailsModel).toJson()
          : data == null
          ? null
          : {
              'materialId': data!.materialId,
              'StaffId': data!.staffId,
              'AccYear': data!.accYear,
              'StandardId': data!.standardId,
              'DivisionId': data!.divisionId,
              'SubjectId': data!.subjectId,
              'Material': data!.material,
              'branchId': data!.branchId,
              'CreatedDate': data!.createdDate,
              'CreatedUser': data!.createdUser,
              'ModifiedDate': data!.modifiedDate,
              'ModifiedUser': data!.modifiedUser,
              'notes': data!.notes,
              'link': data!.link,
              'favorite': data!.favorite,
            },
    };
  }
}

class MaterialDetailsModel extends MaterialDetailsEntity {
  const MaterialDetailsModel({
    super.materialId,
    super.staffId,
    super.accYear,
    super.standardId,
    super.divisionId,
    super.subjectId,
    super.material,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    super.notes,
    super.link,
    super.favorite,
  });

  factory MaterialDetailsModel.fromJson(Map<String, dynamic> json) {
    return MaterialDetailsModel(
      materialId: _toInt(json['materialId']),
      staffId: _toInt(json['StaffId']),
      accYear: json['AccYear']?.toString(),
      standardId: _toInt(json['StandardId']),
      divisionId: _toInt(json['DivisionId']),
      subjectId: _toInt(json['SubjectId']),
      material: _toStringList(json['Material']),
      branchId: _toInt(json['branchId']),
      createdDate: json['CreatedDate']?.toString(),
      createdUser: json['CreatedUser']?.toString(),
      modifiedDate: json['ModifiedDate']?.toString(),
      modifiedUser: json['ModifiedUser']?.toString(),
      notes: json['notes']?.toString(),
      link: json['link']?.toString(),
      favorite: _toBool(json['favorite']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'StaffId': staffId,
      'AccYear': accYear,
      'StandardId': standardId,
      'DivisionId': divisionId,
      'SubjectId': subjectId,
      'Material': material,
      'branchId': branchId,
      'CreatedDate': createdDate,
      'CreatedUser': createdUser,
      'ModifiedDate': modifiedDate,
      'ModifiedUser': modifiedUser,
      'notes': notes,
      'link': link,
      'favorite': favorite,
    };
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;

  final String normalized = value.toString().toLowerCase().trim();

  if (normalized == 'true' || normalized == '1') return true;
  if (normalized == 'false' || normalized == '0') return false;

  return null;
}

List<String> _toStringList(dynamic value) {
  if (value is! List) return const [];

  return value
      .where((item) => item != null)
      .map((item) => item.toString())
      .toList();
}
