import 'package:dr_ai/data/source/firebase/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/feedback_model.dart';
import 'package:equatable/equatable.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  Future<void> submitFeedback({
    required String name,
    required String email,
    required String feedbackText,
    required int rating,
  }) async {
    emit(const FeedbackLoading());

    try {
      if (rating <= 0) {
        emit(const FeedbackError('The rating must be greater than 0.'));
        return;
      }

      final feedback = FeedbackModel(
        name: name,
        email: email,
        feedbackText: feedbackText,
        rating: rating,
      );

      final success = await FirebaseService.submitFeedback(feedback);

      if (success) {
        emit(FeedbackSuccess(feedback));
      } else {
        emit(const FeedbackError(
            "Failed to submit feedback. Please try again later."));
      }
    } catch (e) {
      emit(FeedbackError('خطأ: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(const FeedbackInitial());
  }

  void updateRating(int rating) {
    if (state is FeedbackInitial || state is FeedbackError) {
      emit(RatingUpdated(rating));
    }
  }
}
