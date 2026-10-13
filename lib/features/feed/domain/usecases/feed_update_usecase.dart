import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/utils/typedef.dart';
import 'package:cristalteacher/features/feed/domain/parameters/update_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/repository/feed_repository.dart';

class UpdateFeedUseCase {
  final FeedRepository _feedRepository;

  UpdateFeedUseCase(this._feedRepository);

  ResultFuture<MasterResponseModel> call(
    UpdateFeedParameter params,
    int feedId,
  ) async {
    return _feedRepository.updateFeed(params, feedId);
  }
}
