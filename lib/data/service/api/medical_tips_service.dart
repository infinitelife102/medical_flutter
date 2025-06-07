import 'dart:convert';
import 'package:dio/dio.dart';

import '../../model/medical_tips_model.dart';

class MedicalTipsService {
  final String baseUrl = 'https://drai.pythonanywhere.com/api/daily-tip/';

  Future<MedicalTip> getDailyTip() async {
    try {
      final response = await Dio().get(baseUrl);

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
