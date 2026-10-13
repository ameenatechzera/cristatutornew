// import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';

// class UpdateFeedParameter {
//   final String feedText;
//   final String feedTarget;
//   final List<FeedStandardParameter> standardId;
//   final String userId;
//   final int branchId;
//   final String createdUser;
//   final String accYear;
//   final List<FeedMasterFileParameter> feedMasterFiles;

//   UpdateFeedParameter({
//     required this.feedText,
//     required this.feedTarget,
//     required this.standardId,
//     required this.userId,
//     required this.branchId,
//     required this.createdUser,
//     required this.accYear,
//     required this.feedMasterFiles,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'feedText': feedText,
//       'feedTarget': feedTarget,
//       'StandardId': standardId.map((e) => e.toJson()).toList(),
//       'userId': userId,
//       'branchId': branchId,
//       'CreatedUser': createdUser,
//       'AccYear': accYear,
//       'FeedMasterFiles': feedMasterFiles.map((e) => e.toJson()).toList(),
//     };
//   }
// }
import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';

class UpdateFeedParameter {
  final String feedText;
  final String feedTarget;
  final int status;
  final List<FeedStandardParameter> standardId;
  final String userId;
  final int branchId;
  final String modifiedUser;
  final String accYear;
  final List<dynamic> existingFiles;
  final List<FeedMasterFileParameter> feedMasterFiles;
  final List<String> videoUrl;

  UpdateFeedParameter({
    required this.feedText,
    required this.feedTarget,
    required this.status,
    required this.standardId,
    required this.userId,
    required this.branchId,
    required this.modifiedUser,
    required this.accYear,
    required this.existingFiles,
    required this.feedMasterFiles,
    this.videoUrl = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'feedText': feedText,
      'feedTarget': feedTarget,
      'Status': status,
      'AccYear': accYear,
      'userId': userId,
      'branchId': branchId,
      'StandardId': standardId.map((e) => e.toJson()).toList(),
      'ModifiedUser': modifiedUser,
      'existingFiles': existingFiles,
      'videoUrl': videoUrl,
      'FeedMasterFiles': feedMasterFiles.map((e) => e.toJson()).toList(),
    };
  }
}
