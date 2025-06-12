import 'dart:developer';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcService {
  Future<bool> isNfcAvailable() async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      return availability == NFCAvailability.available;
    } catch (e) {
      log('Error checking NFC availability: $e');
      return false;
    }
  }

  Future<void> readNfcData({
    required Function(Map<String, dynamic> data) onTagDiscovered,
    required Function(String error) onError,
    required Function() onTimeout,
  }) async {
    bool tagDetected = false;

    try {

      final tag =
          await FlutterNfcKit.poll(timeout: const Duration(seconds: 15));
      tagDetected = true;

      final ndef = await FlutterNfcKit.readNDEFRecords();
      if (ndef == null || ndef.isEmpty) {
        log('This tag does not contain NDEF data. Showing raw data...');
        onTagDiscovered({
          'message': 'This tag does not contain NDEF data.',
          'rawData': tag.toJson(),
        });
      } else {
        log('NDEF data found.');
        onTagDiscovered({
          'message': 'NDEF data found.',
          'ndefData': ndef.map((record) => record.toString()).join(', '),
        });
      }
      await stopNfcSession();
    } catch (e) {
      log('Error reading NFC tag: $e');
      if (e.toString().contains('Timeout')) {
        onTimeout();
      } else {
        onError('Error reading NFC tag: $e');
      }
      await stopNfcSession();
    }
  }

  Future<void> stopNfcSession() async {
    try {
      await FlutterNfcKit.finish();
    } catch (e) {
      log('Error stopping NFC session: $e');
    }
  }
}
