import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

// Import the file containing StandardDivisionPair.
// Adjust this path to match your project.
import 'save_material_parameter.dart';

class UpdateMaterialParameter {
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

  const UpdateMaterialParameter({
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
