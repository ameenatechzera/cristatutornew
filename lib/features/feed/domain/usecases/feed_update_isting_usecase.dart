import 'package:cristalteacher/core/usecases/general_usecases.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/feed/domain/entities/feed_updatelisting_entity.dart';
import 'package:cristalteacher/features/feed/domain/repository/feed_repository.dart';

class FetchFeedUpdateListingUseCase
    implements UseCaseWithParams<FeedUpdateListingEntity, int> {
  final FeedRepository _feedRepository;

  FetchFeedUpdateListingUseCase(this._feedRepository);

  @override
  ResultFuture<FeedUpdateListingEntity> call(int feedId) async {
    return _feedRepository.feedUpdateListing(feedId);
  }
}
