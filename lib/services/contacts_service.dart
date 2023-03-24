import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sos_application/services/sms_service.dart';
import 'package:sos_application/utils/shared_pref.dart';

class ContactsService {
  Future<void> addContacts() async {
    bool permissionGranted =
        (await Permission.contacts.request()) == PermissionStatus.granted;
    if (permissionGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact == null) {
        return;
      }
      SharedPref.saveContact(contact.phones.first.number);
    } else {
      throw Exception("Contacts permission not granted");
    }
  }

  Future<void> removeContact(String phone) async {
    try {
      await SharedPref.removeSavedContact(phone);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<String>> getAllContacts() async {
    try {
      return SharedPref.getAllSavedContacts();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> sendSosMessage() async {
    List<String> phones = await getAllContacts();
    await SMSService().sendSms(phones);
  }
}
