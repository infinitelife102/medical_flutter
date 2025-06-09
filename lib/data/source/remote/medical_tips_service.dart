import 'package:dio/dio.dart';

import '../../../core/utils/constant/api_url.dart';
import '../../model/medical_tips_model.dart';

class MedicalTipsService {
  Future<MedicalTip> getDailyTip() async {
    try {
      final response = await Dio().get(EnvManager.medicalTips);

      if (response.statusCode == 200) {
        return MedicalTip.fromJson(response.data);
      } else {
        throw Exception('Failed to load medical tip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching medical tip: $e');
    }
  }
}
