part of 'tutordetails_cubit.dart';

sealed class TutordetailsState extends Equatable {
  const TutordetailsState();

  @override
  List<Object?> get props => [];
}

final class TutordetailsInitial extends TutordetailsState {
  const TutordetailsInitial();
}

final class TutordetailsLoading extends TutordetailsState {
  const TutordetailsLoading();
}

final class TutordetailsSuccess extends TutordetailsState {
  final TutorDetailsEntity tutorDetails;

  const TutordetailsSuccess({required this.tutorDetails});

  @override
  List<Object?> get props => [tutorDetails];
}

final class TutordetailsFailure extends TutordetailsState {
  final String message;

  const TutordetailsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
