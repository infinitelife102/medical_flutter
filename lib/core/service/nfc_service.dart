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
    try {
      log('=== NFC Reading Started ===');

      final tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 15));

      // Print detailed tag information
      log('--- NFC Tag Details ---');
      log('ID: ${tag.id}');
      log('Type: ${tag.type}');
      log('Standard: ${tag.standard}');
      log('ATQA: ${tag.atqa}');
      log('SAK: ${tag.sak}');
      log('Historical Bytes: ${tag.historicalBytes}');
      log('Protocol Info: ${tag.protocolInfo}');
      log('Application Data: ${tag.applicationData}');

      // Print full tag data
      log('--- Full Tag Data (JSON) ---');
      log('${tag.toJson()}');

      // مهم: احتفظ بمعرف البطاقة NFC دائمًا بغض النظر عن وجود بيانات NDEF
      String nfcId = tag.id;

      try {
        final ndef = await FlutterNfcKit.readNDEFRecords();
        if (ndef != null && ndef.isNotEmpty) {
          log('--- NDEF Data Found ---');
          log('Number of NDEF Records: ${ndef.length}');

          // Print each NDEF record
          for (int i = 0; i < ndef.length; i++) {
            final record = ndef[i];
            log('NDEF Record #${i + 1}:');
            log('  Type Name Format: ${record.type}');
            log('  Type: ${record.type}');
            log('  Payload (UTF8): ${record.payload}');
            log('  ID: ${record.id}');
            log('  flags : ${record.flags}');
          }

          final ndefDataString = ndef.map((record) => record.toString()).join(', ');
          log('NDEF Data String: $ndefDataString');

          onTagDiscovered({
            'message': 'NDEF data found.',
            'tagId': nfcId, // دائمًا قم بإرجاع معرف البطاقة
            'ndefData': ndefDataString,
            'ndefRecords': ndef
                .map((record) => {
                      'typeNameFormat': record.type.toString(),
                      'type': record.type,
                      'payload': record.payload,
                      'id': record.id,
                      'flags': record.flags
                    })
                .toList(),
          });
        } else {
          // حتى لو لم يوجد بيانات NDEF، أرجع معرف البطاقة
          log('--- No NDEF Data Found ---');
          log('This tag does not contain NDEF data.');

          onTagDiscovered({
            'message': 'This tag does not contain NDEF data.',
            'tagId': nfcId, // دائمًا قم بإرجاع معرف البطاقة
            'rawData': tag.toJson(),
          });
        }
      } catch (ndefError) {
        // حتى في حالة حدوث خطأ أثناء قراءة NDEF، أرجع معرف البطاقة
        log('--- NDEF Reading Error ---');
        log('Error reading NDEF data: $ndefError');
        log('Continuing with tag ID only');

        onTagDiscovered({
          'message': 'Error reading NDEF data: $ndefError',
          'tagId': nfcId, // دائمًا قم بإرجاع معرف البطاقة
          'rawData': tag.toJson(),
        });
      }

      log('=== NFC Reading Completed ===');
      await stopNfcSession();
    } catch (e) {
      log('=== NFC Reading Error ===');
      log('Error: $e');
      if (e.toString().contains('Timeout')) {
        log('NFC scan timed out');
        onTimeout();
      } else {
        log('Error reading NFC tag: $e');
        onError('Error reading NFC tag: $e');
      }
      await stopNfcSession();
    }
  }

  Future<void> stopNfcSession() async {
    try {
      await FlutterNfcKit.finish();
      log('NFC session finished');
    } catch (e) {
      log('Error stopping NFC session: $e');
    }
  }
}
