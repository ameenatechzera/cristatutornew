import 'package:cristalteacher/features/tutorprofile/domain/entities/tutor_details_entity.dart';

class TutorDetailsModel extends TutorDetailsEntity {
  const TutorDetailsModel({
    super.status,
    super.error,
    super.message,
    super.data,
  });

  factory TutorDetailsModel.fromJson(Map<String, dynamic> json) {
    return TutorDetailsModel(
      status: _parseInt(json['status']),
      error: _parseBool(json['error']),
      message: json['message']?.toString(),
      data: json['data'] is Map
          ? TutorDetailsDataModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'data': data == null
          ? null
          : TutorDetailsDataModel(
              bankDetails: data!.bankDetails,
              contactInfo: data!.contactInfo,
              personalInfo: data!.personalInfo,
              employeeLocationAndDetails: data!.employeeLocationAndDetails,
            ).toJson(),
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;

    if (value is bool) return value;

    final String convertedValue = value.toString().toLowerCase();

    if (convertedValue == 'true' || convertedValue == '1') {
      return true;
    }

    if (convertedValue == 'false' || convertedValue == '0') {
      return false;
    }

    return null;
  }
}

class TutorDetailsDataModel extends TutorDetailsDataEntity {
  const TutorDetailsDataModel({
    super.bankDetails,
    super.contactInfo,
    super.personalInfo,
    super.employeeLocationAndDetails,
  });

  factory TutorDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return TutorDetailsDataModel(
      bankDetails: _parseStringList(json['Bank Details']),
      contactInfo: _parseStringList(json['Contact Info']),
      personalInfo: _parseStringList(json['Personal Info']),
      employeeLocationAndDetails: _parseStringList(
        json['Employee Location & Details'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Bank Details': bankDetails,
      'Contact Info': contactInfo,
      'Personal Info': personalInfo,
      'Employee Location & Details': employeeLocationAndDetails,
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }
}
