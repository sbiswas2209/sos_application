import 'package:geolocator/geolocator.dart';
import 'package:sos_application/utils/config.dart';
import 'package:telephony/telephony.dart';

class SMSService {
  final Telephony telephony = Telephony.instance;

  Future<void> sendSms(List<String> phones,
      {String? helpRequestMessage}) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted ?? false) {
      Position currentPosition = await _determinePosition();
      for (String phone in phones) {
        await telephony.sendSms(
          to: phone,
          message: helpRequestMessage ??
              DEFAULT_HELP_MESSAGE(position: currentPosition),
        );
      }
    } else {
      throw Exception("Send SMS permission not granted.");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
