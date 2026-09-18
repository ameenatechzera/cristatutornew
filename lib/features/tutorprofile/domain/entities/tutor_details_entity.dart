class TutorDetailsEntity {
  final int? status;
  final bool? error;
  final String? message;
  final TutorDetailsDataEntity? data;

  const TutorDetailsEntity({this.status, this.error, this.message, this.data});
}

class TutorDetailsDataEntity {
  final List<String> bankDetails;
  final List<String> contactInfo;
  final List<String> personalInfo;
  final List<String> employeeLocationAndDetails;

  const TutorDetailsDataEntity({
    this.bankDetails = const [],
    this.contactInfo = const [],
    this.personalInfo = const [],
    this.employeeLocationAndDetails = const [],
  });
}
