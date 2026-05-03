import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  static Future<String> getCurrentLocationName() async {
    // 1. تحقق هل الخدمة مفعلة
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // 2. تحقق من الإذن
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    // 3. جلب الموقع
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4. تحويله لمدينة
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;

    return place.locality ??
        place.subAdministrativeArea ??
        place.administrativeArea ??
        'Unknown';
  }
}