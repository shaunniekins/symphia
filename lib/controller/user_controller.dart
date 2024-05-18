// user_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  RxString name = ''.obs;
  RxString birthday = ''.obs;
  var selectedInterests = <String, Set<String>>{}.obs;

  @override
  void onInit() {
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  void saveName(String newName) {
    name.value = newName;
  }

  void saveBirthday(String newBirthday) {
    birthday.value = newBirthday;
  }

  void saveSelectedInterests(Map<String, Set<String>> newSelectedInterests) {
    selectedInterests.value = newSelectedInterests;
  }
}
