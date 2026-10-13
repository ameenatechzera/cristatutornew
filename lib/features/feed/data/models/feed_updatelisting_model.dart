import 'dart:convert';

import 'package:cristalteacher/features/feed/domain/entities/feed_updatelisting_entity.dart';

class FeedUpdateListingModel extends FeedUpdateListingEntity {
  const FeedUpdateListingModel({
    required super.feedId,
    required super.feedText,
    required super.feedTarget,
    required super.standardDivisionList,
    required super.userId,
    required super.branchId,
    required super.createdDate,
    required super.createdUser,
    super.modifiedDate,
    super.modifiedUser,
    required super.accYear,
    super.videoUrl,
    required super.files,
  });

  // Pass the inner "data" object here.
  factory FeedUpdateListingModel.fromJson(Map<String, dynamic> json) {
    final rawStandardId = json['StandardId'];

    final List<dynamic> standardDivisions;
    if (rawStandardId is String && rawStandardId.trim().isNotEmpty) {
      standardDivisions = jsonDecode(rawStandardId) as List<dynamic>;
    } else if (rawStandardId is List) {
      standardDivisions = rawStandardId;
    } else {
      standardDivisions = [];
    }

    return FeedUpdateListingModel(
      feedId: _toInt(json['feedId']),
      feedText: json['feedText']?.toString() ?? '',
      feedTarget: json['feedTarget']?.toString() ?? '',
      standardDivisionList: standardDivisions
          .map(
            (item) => FeedStandardDivisionModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      userId: json['userId']?.toString() ?? '',
      branchId: _toInt(json['branchId']),
      createdDate: json['CreatedDate']?.toString() ?? '',
      createdUser: json['CreatedUser']?.toString() ?? '',
      modifiedDate: json['ModifiedDate']?.toString(),
      modifiedUser: json['ModifiedUser']?.toString(),
      accYear: json['AccYear']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString(),
      files: (json['files'] as List? ?? [])
          .map(
            (item) => FeedUpdateFileModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedId': feedId,
      'feedText': feedText,
      'feedTarget': feedTarget,
      'StandardId': jsonEncode(
        standardDivisionList
            .map(
              (item) => {
                'StandardId': item.standardId,
                'DivisionId': item.divisionId,
              },
            )
            .toList(),
      ),
      'userId': userId,
      'branchId': branchId,
      'CreatedDate': createdDate,
      'CreatedUser': createdUser,
      'ModifiedDate': modifiedDate,
      'ModifiedUser': modifiedUser,
      'AccYear': accYear,
      'videoUrl': videoUrl,
      'files': files.map((file) => {'image': file.image}).toList(),
    };
  }
}

class FeedStandardDivisionModel extends FeedStandardDivisionEntity {
  const FeedStandardDivisionModel({
    required super.standardId,
    required super.divisionId,
  });

  factory FeedStandardDivisionModel.fromJson(Map<String, dynamic> json) {
    return FeedStandardDivisionModel(
      standardId: _toInt(json['StandardId']),
      divisionId: _toInt(json['DivisionId']),
    );
  }

  Map<String, dynamic> toJson() => {
    'StandardId': standardId,
    'DivisionId': divisionId,
  };
}

class FeedUpdateFileModel extends FeedUpdateFileEntity {
  const FeedUpdateFileModel({required super.image});

  factory FeedUpdateFileModel.fromJson(Map<String, dynamic> json) {
    return FeedUpdateFileModel(image: json['image']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'image': image};
}

int _toInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
