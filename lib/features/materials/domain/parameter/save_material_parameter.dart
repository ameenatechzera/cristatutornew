import 'dart:io';

class StandardDivisionPair {
  final int standardId;
  final int divisionId;

  StandardDivisionPair({
    required this.standardId,
    required this.divisionId,
  });

  Map<String, dynamic> toJson() => {
    'StandardId': standardId,
    'DivisionId': divisionId,
  };
}

class SaveMaterialParameter {
  final List<File> materials;
  final int staffId;
  final String accYear;
  final List<StandardDivisionPair> standardDivisionList; // <-- replaces standardId & divisionId
  final int subjectId;
  final int branchId;
  final String createdUser;
  final String documentName;
  final String notes;
  final String link;
  final bool favorite;

  SaveMaterialParameter({
    required this.materials,
    required this.staffId,
    required this.accYear,
    required this.standardDivisionList,
    required this.subjectId,
    required this.branchId,
    required this.createdUser,
    required this.documentName,
    required this.notes,
    required this.link,
    required this.favorite,
  });
}