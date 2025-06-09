import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/model/medical_tips_model.dart';
import '../../data/source/remote/medical_tips_service.dart';

part 'medical_tips_state.dart';

class MedicalTipsCubit extends Cubit<MedicalTipsState> {
  final MedicalTipsService _medicalTipsService = MedicalTipsService();

  MedicalTipsCubit() : super(MedicalTipsInitial());

  Future<void> fetchDailyTip() async {
    try {
      emit(MedicalTipsLoading());
      final medicalTip = await _medicalTipsService.getDailyTip();
      emit(MedicalTipsLoaded(medicalTip));
    } catch (e) {
      emit(MedicalTipsError(e.toString()));
    }
  }
}
