import 'package:location/location.dart';
import 'dart:developer';
import 'scaffold_snakbar.dart';

class LocationHelper {
  static final Location _location = Location();

  static Future<LocationData?> determineCurrentPosition(context) async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    //* Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        customSnackBar(context, "Location services are disabled.");
        return null;
      }
    }

    //* Check for location permissions
    permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        log('Location permissions are denied.');
        customSnackBar(context, "Location permissions are denied.");
        return null;
      }
    }

    if (permissionStatus == PermissionStatus.deniedForever) {
      log('Location permissions are permanently denied.');
      customSnackBar(context, "Location permissions are permanently denied.");
      return null;
    }

    //* Try to get the last known position first for faster feedback
    LocationData? locationData;
    try {
      locationData = await _location.getLocation();
      log('Current position: ${locationData.latitude}, ${locationData.longitude}');
      return locationData;
    } catch (err) {
      log('Error getting current position: $err');
      customSnackBar(context, "Error getting current position.");
      return null;
    }
  }
}
