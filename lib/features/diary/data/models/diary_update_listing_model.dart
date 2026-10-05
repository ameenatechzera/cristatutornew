import 'package:cristalteacher/features/diary/domain/entities/update_listing_entity.dart';

class DiaryUpdateListingResponseModel extends DiaryUpdateListingEntity {
  DiaryUpdateListingResponseModel({
    super.status,
    super.error,
    super.message,
    DiaryUpdateListingModel? super.data,
  });

  factory DiaryUpdateListingResponseModel.fromJson(Map<String, dynamic> json) {
    return DiaryUpdateListingResponseModel(
      status: json['status'] as int?,
      error: json['error'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] is Map
          ? DiaryUpdateListingModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }
}

class DiaryUpdateListingModel extends DiaryUpdateListingData {
  DiaryUpdateListingModel({
    super.diaryId,
    super.accYear,
    super.standardDivision,
    super.subjectId,
    super.employeeId,
    super.diaryType,
    super.diaryTitle,
    super.description,
    super.diaryDate,
    super.dueDate,
    super.isActive,
    super.isFavourite,
    super.branchId,
    super.createdDate,
    super.createdUser,
    super.files,
    super.videoUrl,
  });

  factory DiaryUpdateListingModel.fromJson(Map<String, dynamic> json) {
    return DiaryUpdateListingModel(
      diaryId: toInt(json['diaryId']),
      accYear: json['AccYear']?.toString(),
      // The backend sends class pairs inside StandardDivision.
      standardDivision: (json['StandardDivision'] as List?)
          ?.whereType<Map>()
          .map(
            (item) => DiaryStandardDivisionModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      subjectId: toInt(json['SubjectId']),
      employeeId: toInt(json['EmployeeId']),
      diaryType: toInt(json['diaryType']),
      diaryTitle: json['diaryTitle']?.toString(),
      description: json['Description']?.toString(),
      diaryDate: json['diaryDate']?.toString(),
      dueDate: json['dueDate']?.toString(),
      isActive: _toBool(json['isActive']),
      isFavourite: _toBool(json['isFavourite']),
      branchId: toInt(json['branchId']),
      createdDate: json['CreatedDate']?.toString(),
      createdUser: json['CreatedUser']?.toString(),
      files: (json['files'] as List?)
          ?.where((file) => file != null)
          .map((file) => file.toString())
          .toList(),
      videoUrl: json['videoUrl']?.toString(),
    );
  }

  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString());
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;

    final normalizedValue = value.toString().trim().toLowerCase();

    if (normalizedValue == 'true' || normalizedValue == '1') {
      return true;
    }

    if (normalizedValue == 'false' || normalizedValue == '0') {
      return false;
    }

    return null;
  }
}

class DiaryStandardDivisionModel extends DiaryStandardDivisionEntity {
  const DiaryStandardDivisionModel({
    required super.standardId,
    super.standard,
    required super.divisionId,
    super.division,
  });

  factory DiaryStandardDivisionModel.fromJson(Map<String, dynamic> json) {
    final int? standardId = DiaryUpdateListingModel.toInt(json['StandardId']);
    final int? divisionId = DiaryUpdateListingModel.toInt(json['DivisionId']);

    if (standardId == null || divisionId == null) {
      throw FormatException('Invalid StandardDivision item: $json');
    }

    return DiaryStandardDivisionModel(
      standardId: standardId,
      standard: json['Standard']?.toString(),
      divisionId: divisionId,
      division: json['Division']?.toString(),
    );
  }
}
