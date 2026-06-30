import '../ApiService.dart';

class NoteService {
  static Future<dynamic> createNote({
    required int pharmacyId,
    required String noteType,
    required String noteContent,
  }) async {
    final response = await ApiService.post(
      "/erp/v1/pharmacies/$pharmacyId/notes",
      data: {
        "note_type": noteType.toLowerCase(),
        "note": noteContent,
      },
    );

    return response.data;
  }
}