import 'package:get/get.dart';
import '../../services/ServiceApi/ProfileService.dart';
import 'Profile_Model.dart';


class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileData = Rxn<ProfileData>();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      final result = await ProfileService.fetchProfile();
      if (result != null && result.isSuccess && result.data != null) {
        profileData.value = result.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}