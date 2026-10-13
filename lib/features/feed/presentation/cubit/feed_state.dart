part of 'feed_cubit.dart';

sealed class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

final class FeedInitial extends FeedState {}

class FetchFeedLoading extends FeedState {}

class FetchFeedSuccess extends FeedState {
  final FetchFeedEntity response;

  const FetchFeedSuccess(this.response);
}

class FetchFeedFailure extends FeedState {
  final String message;

  const FetchFeedFailure(this.message);
}

class SaveFeedLoading extends FeedState {}

class SaveFeedSuccess extends FeedState {
  final MasterResponseModel response;

  const SaveFeedSuccess(this.response);
}

class SaveFeedFailure extends FeedState {
  final String message;

  const SaveFeedFailure(this.message);
}

class DeleteFeedLoading extends FeedState {}

class DeleteFeedSuccess extends FeedState {
  final MasterResponseModel response;

  const DeleteFeedSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class DeleteFeedFailure extends FeedState {
  final String message;

  const DeleteFeedFailure(this.message);

  @override
  List<Object> get props => [message];
}

class FetchFeedUpdateListingLoading extends FeedState {}

class FetchFeedUpdateListingSuccess extends FeedState {
  final FeedUpdateListingEntity response;

  const FetchFeedUpdateListingSuccess(this.response);
}

class FetchFeedUpdateListingFailure extends FeedState {
  final String message;

  const FetchFeedUpdateListingFailure(this.message);
}

class UpdateFeedLoading extends FeedState {}

class UpdateFeedSuccess extends FeedState {
  final MasterResponseModel response;

  const UpdateFeedSuccess(this.response);
}

class UpdateFeedFailure extends FeedState {
  final String message;

  const UpdateFeedFailure(this.message);
}
