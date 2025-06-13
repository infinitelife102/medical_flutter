part of 'medical_record_cubit.dart';

class MedicalRecordState extends Equatable {
  final String url;
  final bool isLoading;

  const MedicalRecordState({required this.url, required this.isLoading});

  factory MedicalRecordState.initial() {
    return const MedicalRecordState(
      url: '',
      isLoading: true,
    );
  }

  MedicalRecordState copyWith({
    String? url,
    bool? isLoading,
  }) {
    return MedicalRecordState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [url, isLoading];
}
