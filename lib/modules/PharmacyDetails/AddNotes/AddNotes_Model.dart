class CreateNoteModel {
  final String noteType;
  final String note;

  CreateNoteModel({
    required this.noteType,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "note_type": noteType.toLowerCase(),
      "note": note,
    };
  }
}