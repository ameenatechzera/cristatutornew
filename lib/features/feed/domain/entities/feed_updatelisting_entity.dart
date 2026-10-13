// feed_update_listing_entity.dart

class FeedUpdateListingEntity {
  final int feedId;
  final String feedText;
  final String feedTarget;
  final List<FeedStandardDivisionEntity> standardDivisionList;
  final String userId;
  final int branchId;
  final String createdDate;
  final String createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final String accYear;
  final String? videoUrl;
  final List<FeedUpdateFileEntity> files;

  const FeedUpdateListingEntity({
    required this.feedId,
    required this.feedText,
    required this.feedTarget,
    required this.standardDivisionList,
    required this.userId,
    required this.branchId,
    required this.createdDate,
    required this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    required this.accYear,
    this.videoUrl,
    required this.files,
  });
}

class FeedStandardDivisionEntity {
  final int standardId;
  final int divisionId;

  const FeedStandardDivisionEntity({
    required this.standardId,
    required this.divisionId,
  });
}

class FeedUpdateFileEntity {
  final String image;

  const FeedUpdateFileEntity({required this.image});
}
