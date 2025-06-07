part of 'medical_tips_cubit.dart';

@immutable
sealed class MedicalTipsState {}

final class MedicalTipsInitial extends MedicalTipsState {}

final class MedicalTipsLoading extends MedicalTipsState {}

final class MedicalTipsLoaded extends MedicalTipsState {
  final MedicalTip medicalTip;

  MedicalTipsLoaded(this.medicalTip);
}

final class MedicalTipsError extends MedicalTipsState {
  final String message;

  MedicalTipsError(this.message);
}
