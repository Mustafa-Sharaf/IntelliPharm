import '../../modules/AddNotes/AddNotes_Model.dart';
import '../ApiService.dart';


class PharmacyNotesService {
  static Future<bool> addPharmacyNote({
    required int pharmacyId,
    required CreateNoteModel noteData,
  }) async {
    final response = await ApiService.post(
      "/erp/v1/pharmacies/$pharmacyId/notes",
      data: noteData.toJson(),
    );

    if (response.data["isSuccess"] == true) {
      return true;
    } else {
      throw Exception(response.data["message"] ?? "Failed to add note");
    }
  }
}