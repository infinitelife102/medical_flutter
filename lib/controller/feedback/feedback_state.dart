part of 'feedback_cubit.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

class FeedbackLoading extends FeedbackState {
  const FeedbackLoading();
}

class RatingUpdated extends FeedbackState {
  final int rating;

  const RatingUpdated(this.rating);

  @override
  List<Object?> get props => [rating];
}

class FeedbackSuccess extends FeedbackState {
  final FeedbackModel feedback;

  const FeedbackSuccess(this.feedback);

  @override
  List<Object?> get props => [feedback];
}

class FeedbackError extends FeedbackState {
  final String errorMessage;

  const FeedbackError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
