import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/feed/domain/entities/feed_updatelisting_entity.dart';
import 'package:cristalteacher/features/feed/domain/parameters/fetch_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/entities/fetch_feed_entity.dart';
import 'package:cristalteacher/features/feed/domain/parameters/update_feed_parameter.dart';

abstract class FeedRepository {
  ResultFuture<FetchFeedEntity> fetchFeed(FetchFeedParams params);

  ResultFuture<MasterResponseModel> saveFeed(SaveFeedParameter request);
  ResultFuture<MasterResponseModel> deleteFeed(int id);
  ResultFuture<FeedUpdateListingEntity> feedUpdateListing(int feedId);
  ResultFuture<MasterResponseModel> updateFeed(
    UpdateFeedParameter params,
    int feedId,
  );
}
