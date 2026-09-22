class ApiConstants {
  /// Returns the full URL for Register / Get Company endpoint
  static String getRegisterServerPath(String baseUrl) {
    return '$baseUrl/company/get-company';
  }

  /// Returns the full URL for Login endpoint
  static String getLoginPath(String baseUrl) {
    return '${baseUrl}login';
  }

  // static String getFetchSchoolPath(String baseUrl) {
  //   return '${baseUrl}get-school';
  // }

  static String getBranchDetailsPath(String baseUrl) {
    return '${baseUrl}app/branch-byid/1';
  }

  static String getAttendanceDetailsPath(String baseUrl) {
    return '${baseUrl}student-report/by-filter';
  }

  /// Returns the full URL for Fees / Get Acc Years
  static String getAccYearsServerPath(String baseUrl) {
    return '${baseUrl}app/accyears/1';
  }

  static String getSaveAttendancePath(String baseUrl) {
    return '${baseUrl}save-StudentAttendanceMaster';
  }

  static String getDiaryDetailsPath(String baseUrl) {
    return '${baseUrl}classdiary';
  }

  static String getSaveDiaryPath(String baseUrl) {
    return '${baseUrl}save-classdiary';
  }

  static String getFeedReportPath(String baseUrl) {
    return '${baseUrl}feed-report';
  }

  static String getSaveFeedPath(String baseUrl) {
    return '${baseUrl}save-feedmaster';
  }

  static String getFetchMaterialPath(String baseUrl) {
    return '${baseUrl}app/get-material-list';
  }

  static String saveMaterialPath(String baseUrl) {
    return '${baseUrl}app/save-material';
  }

  static String getMarkEntryPath(String baseUrl) {
    return '${baseUrl}exam-mark-entry/show-by-branch';
  }

  static String getGradePlanPath(String baseUrl) {
    return '${baseUrl}exam-grade-plans-data/1';
  }

  static String getAllExamPath(String baseUrl) {
    return '${baseUrl}get-allexams/1';
  }

  static String saveExamMarksPath(String baseUrl) {
    return '${baseUrl}exam-mark-entry/store';
  }

  static String getAttendanceReportPath(String baseUrl) {
    return '${baseUrl}app/teacher-wise-attendance';
  }

  static String deleteExamMarkPath(String baseUrl) {
    return '${baseUrl}exam-mark-entry/delete/';
  }

  static String deleteDiaryPath(String baseUrl) {
    return '${baseUrl}delete-classdiary/';
  }

  static String getDeleteFeedPath(String baseUrl) {
    return '${baseUrl}delete-feedmaster/';
  }

  static String updateExamMarksPath(String baseUrl) {
    return '${baseUrl}exam-mark-entry/update/';
  }

  static String getStudentAttendancePath(String baseUrl) {
    return '${baseUrl}StudentAttendanceMaster-byid/';
  }

  static String getUpdateStudentAttendancePath(String baseUrl) {
    return '${baseUrl}update-StudentAttendanceMaster/';
  }

  static String getMarkEntryDetailsPath(String baseUrl) {
    return '${baseUrl}exam-mark-entry/show-by-id/';
  }

  static String getTeacherTimetablePath(String baseUrl) {
    return '${baseUrl}teacher-timetable';
  }

  static String getGatePassPath(String baseUrl) {
    return '${baseUrl}earlygoing-request-staff';
  }

  static String getUpdateGatePassPath(String baseUrl) {
    return '${baseUrl}update-earlygoingrequest';
  }

  static String getWorkPlanPath(String baseUrl) {
    return '${baseUrl}get-all-staffworkplan';
  }

  static String getWorkPlanDetailsPath(String baseUrl) {
    return '${baseUrl}get-all-staffworkplandetails';
  }

  static String saveWorkPlanPath(String baseUrl) {
    return '${baseUrl}save-staffworkplandetails';
  }

  /// Returns Teacher Dashboard
  static String getTeacherDashboardPath(String baseUrl) {
    return '${baseUrl}teacher-dashboard';
  }

  /// Returns update diarylisitng
  static String getDiaryUpdateListingPath(String baseUrl) {
    return '${baseUrl}get-classdiary';
  }

  /// Returns update diary
  static String getUpdateDiaryPath(String baseUrl) {
    return '${baseUrl}update-classdiary';
  }

  /// Returns examlisting
  static String getExamListingPath(String baseUrl) {
    return '${baseUrl}get-allexams/1';
  }

  /// Returns exam types URL.
  static String getExamTypesPath(String baseUrl, int branchId) {
    final String normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl
        : '$baseUrl/';

    return '${normalizedBaseUrl}ExamTypes/$branchId';
  }

  /// Returns examtermslisting
  static String getExamTermsPath(String baseUrl) {
    return '${baseUrl}ExamTerms/1';
  }

  /// saveexam
  static String saveExamPath(String baseUrl) {
    return '${baseUrl}save-exam';
  }

  /// Delete exam
  static String deleteExamPath(String baseUrl, int examId) {
    return '${baseUrl}delete-exam/$examId';
  }

  /// Update exam
  static String updateExamPath(String baseUrl, int examId) {
    return '${baseUrl}update-exam/$examId';
  }

  /// gettutordetails
  static String getTutorDetailsPath(String baseUrl) {
    return '${baseUrl}app/employee-details/1';
  }

  //Monthly Report Attendance
  static String getMonthlyAttendancePath(String baseUrl) {
    return '${baseUrl}class-wise-attendance-report-bymonth';
  }

  /// Delete material
  static String deleteMaterialPath(String baseUrl, int materialId) {
    return '${baseUrl}delete-material/$materialId';
  }

  /// Delete material
  static String getMaterialDetailsPath(String baseUrl, int materialId) {
    return '${baseUrl}material-byid/$materialId';
  }
}
