// import 'dart:io';

// class StandardDivisionPair {
//   final int standardId;
//   final int divisionId;

//   StandardDivisionPair({
//     required this.standardId,
//     required this.divisionId,
//   });

//   Map<String, dynamic> toJson() => {
//     'StandardId': standardId,
//     'DivisionId': divisionId,
//   };
// }

// class SaveMaterialParameter {
//   final List<File> materials;
//   final int staffId;
//   final String accYear;
//   final List<StandardDivisionPair> standardDivisionList; // <-- replaces standardId & divisionId
//   final int subjectId;
//   final int branchId;
//   final String createdUser;
//   final String documentName;
//   final String notes;
//   final String link;
//   final bool favorite;

//   SaveMaterialParameter({
//     required this.materials,
//     required this.staffId,
//     required this.accYear,
//     required this.standardDivisionList,
//     required this.subjectId,
//     required this.branchId,
//     required this.createdUser,
//     required this.documentName,
//     required this.notes,
//     required this.link,
//     required this.favorite,
//   });
// }
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class StandardDivisionPair {
  final int standardId;
  final int divisionId;

  const StandardDivisionPair({
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
  final List<StandardDivisionPair> standardDivisionList;
  final int subjectId;
  final int branchId;
  final String createdUser;
  final String documentName;
  final String notes;
  final String link;
  final bool favorite;

  const SaveMaterialParameter({
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

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('StaffId', staffId.toString()),
      MapEntry('AccYear', accYear),
      MapEntry(
        'StandardId',
        jsonEncode(standardDivisionList.map((pair) => pair.toJson()).toList()),
      ),
      MapEntry('SubjectId', subjectId.toString()),
      MapEntry('branchId', branchId.toString()),
      MapEntry('CreatedUser', createdUser),
      MapEntry('documentName', documentName),
      MapEntry('notes', notes),
      MapEntry('link', link),
      MapEntry('favorite', favorite.toString()),
    ]);

    for (final file in materials) {
      formData.files.add(
        MapEntry(
          'Material',
          await MultipartFile.fromFile(
            file.path,
            filename: file.uri.pathSegments.last,
          ),
        ),
      );
    }

    return formData;
  }
}
