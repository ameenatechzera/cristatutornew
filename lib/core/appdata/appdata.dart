import 'package:cristalteacher/features/authentication/domain/entities/class_details_entity.dart';
import 'package:cristalteacher/features/authentication/domain/entities/fetch_accyear_entity.dart';
import 'package:flutter/material.dart';

class AppData {
  static String appVersion =
      '2.2'; //extra 1 not passing issue (formtype) fixed 05-02-2026
  static String? admissionNo;
  static String? studentName;
  static String? studentStdId;
  static String? studentDivId;
  static String? accYear;
  static String? dob;
  static String? profileUrl;
  static String? gender;
  static String? schoolName;
  // Simple global state manager
  static ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);
  //final deleteButtonNotifier = ValueNotifier<bool>(false);
  static String? branchName;
  static String? logo;
  static String? place;
  static String? studentClass;
  static int? branchId;
  static bool feeCollectionStatus = false;
  static int? employeeId;
  static int? userId;
  static String? teacherName;
  static String?
  teacherSubject; // Tutorship data of the currently logged-in teacher.
  static List<TutorshipClass> tutorshipClasses = [];
  static List<AccYearEntity> accYearsList =[];

  // Complete standard list from data.Standard.
  static List<TutorshipClass> standards = [];

  static bool get hasTutorshipData {
    return tutorshipClasses.isNotEmpty || standards.isNotEmpty;
  }

  static void saveAccYearsList({
    required List<AccYearEntity> accYearList,
  }) {
    accYearsList = List<AccYearEntity>.from(accYearList);
  }

  static void saveTutorshipData({
    required List<TutorshipClass> tutorshipList,
    required List<TutorshipClass> standardList,
  }) {
    tutorshipClasses = List<TutorshipClass>.from(tutorshipList);
    standards = List<TutorshipClass>.from(standardList);
  }

  static void clearTutorshipData() {
    tutorshipClasses = [];
    standards = [];
  }

  static void clearTeacherSession() {
    accYear = null;
    branchId = null;
    branchName = null;
    employeeId = null;
    userId = null;
    teacherName = null;
    teacherSubject = null;

    clearTutorshipData();
  }
}
