import 'package:get/get.dart';

class SettingsController extends GetxController {


  bool? _isAppModeDart = false;
  bool _isNotificationSoundActive = false;

  bool get  isNotificationSoundActive => _isNotificationSoundActive;
  String? selectedLanguage = 'EN';
  bool get isAppModeDark => _isAppModeDart!;

  toggleSound(){
    _isNotificationSoundActive = !_isNotificationSoundActive;
    update();
  }





}