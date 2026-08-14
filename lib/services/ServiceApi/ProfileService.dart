import '../../modules/Profile/Profile_Model.dart';
import '../../services/ApiService.dart';


class ProfileService {
  static Future<ProfileModel?> fetchProfile() async {
    try {
      final response = await ApiService.get('/erp/v1/employees/profile');
      if (response.statusCode == 200 && response.data != null) {
        return ProfileModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    return null;
  }
}