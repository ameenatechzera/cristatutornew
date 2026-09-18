import 'package:bloc/bloc.dart';
import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';
import 'package:cristalteacher/features/tutorprofile/domain/usecases/fetch_tutor_details_usecase.dart';
import 'package:equatable/equatable.dart';

part 'tutordetails_state.dart';

class TutordetailsCubit extends Cubit<TutordetailsState> {
  final FetchTutorDetailsUseCase _fetchTutorDetailsUseCase;

  TutordetailsCubit(this._fetchTutorDetailsUseCase)
    : super(const TutordetailsInitial());

  Future<void> fetchTutorDetails() async {
    emit(const TutordetailsLoading());

    final result = await _fetchTutorDetailsUseCase();

    result.fold(
      (failure) {
        emit(TutordetailsFailure(message: failure.message));
      },
      (tutorDetails) {
        emit(TutordetailsSuccess(tutorDetails: tutorDetails));
      },
    );
  }
}
