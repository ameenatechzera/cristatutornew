import 'dart:convert';

import 'package:cristalteacher/core/errors/error_messege_model.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/network/api_endpoints.dart';
import 'package:cristalteacher/core/network/api_helper.dart';
import 'package:cristalteacher/features/attendance/data/models/attendance_report_model.dart';
import 'package:cristalteacher/features/attendance/data/models/fetch_attendancedetails_model.dart';
import 'package:cristalteacher/features/attendance/data/models/monthly_attendanceResultModel.dart';
import 'package:cristalteacher/features/attendance/data/models/studentattendance_response_model.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/attendance_report_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/fetch_attendancedetails_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/monthlyAttendanceRequest.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/save_attendance_parameter.dart';
import 'package:cristalteacher/features/attendance/domain/parameters/update_studentattendance_parameter.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:dio/dio.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceDetailsResponseModel> fetchAttendanceDetails(
    AttendanceDetailsRequest params,
  );
  Future<MasterResponseModel> saveAttendance(SaveAttendanceRequest params);
  Future<AttendanceReportResponseModel> fetchAttendanceReport(
    AttendanceReportParameter params,
  );
  Future<StudentAttendanceResponseModel> fetchStudentAttendance(int studentId);
  Future<MasterResponseModel> updateStudentAttendance(
    int studentAttendanceMasterId,
    UpdateStudentAttendanceParameter params,
  );
  Future<MonthlyAttendanceModel> fetchMonthlyAttendance(MonthlyAttendanceRequest request);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<AttendanceDetailsResponseModel> fetchAttendanceDetails(
    AttendanceDetailsRequest params,
  ) async {
    print('📘 Attendance Details Called');
    print('AttendanceDetailsRequest: ${params.toJson()}');

    try {
      /// Base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      /// API URL
      final url = ApiConstants.getAttendanceDetailsPath(baseUrl);

      print("URL : $url");

      /// Headers
      final options = await ApiHelper.getAuthOptions(withToken: true);

      /// API Call
      final response = await dio.post(
        url,
        data: params.toJson(),
        options: options,
      );

      print('📘 Status Code: ${response.statusCode}');

      final responseString = jsonEncode(response.data);

      const chunkSize = 800;

      for (int i = 0; i < responseString.length; i += chunkSize) {
        print(
          responseString.substring(
            i,
            i + chunkSize > responseString.length
                ? responseString.length
                : i + chunkSize,
          ),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendanceDetailsResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception in fetchAttendanceDetails: $e');
      print(stacktrace);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> saveAttendance(
    SaveAttendanceRequest params,
  ) async {
    print('📘 Save Attendance Called');
    print('SaveAttendanceRequest: ${params.toJson()}');

    try {
      /// Base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      /// API URL
      final url = ApiConstants.getSaveAttendancePath(baseUrl);

      print("URL : $url");

      /// Headers
      final options = await ApiHelper.getAuthOptions(withToken: true);

      /// API Call
      final response = await dio.post(
        url,
        data: params.toJson(),
        options: options,
      );

      print('📘 Status Code: ${response.statusCode}');
      print('📘 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception in saveAttendance: $e');
      print(stacktrace);
      rethrow;
    }
  }

  // @override
  // Future<AttendanceReportResponseModel> fetchAttendanceReport(
  //   AttendanceReportParameter params,
  // ) async {
  //   print('📘 Attendance Report Called');

  //   try {
  //     /// Base URL
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception("Base URL not set");
  //     }

  //     /// API URL
  //     final url = ApiConstants.getAttendanceReportPath(baseUrl);

  //     print("URL : $url");

  //     /// Headers
  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     /// API Call
  //     final response = await dio.post(url, options: options);

  //     print('📘 Status Code: ${response.statusCode}');

  //     final responseString = jsonEncode(response.data);

  //     const chunkSize = 800;

  //     for (int i = 0; i < responseString.length; i += chunkSize) {
  //       print(
  //         responseString.substring(
  //           i,
  //           i + chunkSize > responseString.length
  //               ? responseString.length
  //               : i + chunkSize,
  //         ),
  //       );
  //     }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return AttendanceReportResponseModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //       );
  //     }
  //   } catch (e, stacktrace) {
  //     print('❌ Exception in fetchAttendanceReport: $e');
  //     print(stacktrace);
  //     rethrow;
  //   }
  // }
  // @override
  // Future<AttendanceReportResponseModel> fetchAttendanceReport(
  //   AttendanceReportParameter params,
  // ) async {
  //   print('📘 Attendance Report Called');

  //   try {
  //     /// Base URL
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception("Base URL not set");
  //     }

  //     /// API URL
  //     final url = ApiConstants.getAttendanceReportPath(baseUrl);

  //     print("📘 URL : $url");

  //     /// Request
  //     print("📘 Attendance Request: ${params.toJson()}");

  //     /// Headers
  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     /// API Call
  //     final response = await dio.post(
  //       url,
  //       data: params.toJson(), // ⭐ THIS WAS MISSING
  //       options: options,
  //     );

  //     print('📘 Status Code: ${response.statusCode}');

  //     final responseString = jsonEncode(response.data);

  //     const chunkSize = 800;

  //     for (int i = 0; i < responseString.length; i += chunkSize) {
  //       print(
  //         responseString.substring(
  //           i,
  //           i + chunkSize > responseString.length
  //               ? responseString.length
  //               : i + chunkSize,
  //         ),
  //       );
  //     }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return AttendanceReportResponseModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //       );
  //     }
  //   } catch (e, stacktrace) {
  //     print('❌ Exception in fetchAttendanceReport: $e');
  //     print(stacktrace);
  //     rethrow;
  //   }
  // }
  @override
  Future<AttendanceReportResponseModel> fetchAttendanceReport(
    AttendanceReportParameter params,
  ) async {
    print('📘 Attendance Report Called');

    try {
      /// Base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      /// API URL
      final url = ApiConstants.getAttendanceReportPath(baseUrl);

      print("📘 URL : $url");

      /// Request
      print("📘 Attendance Request: ${params.toJson()}");

      /// Headers
      final options = await ApiHelper.getAuthOptions(withToken: true);

      /// API Call
      final response = await dio.post(
        url,
        data: params.toJson(),
        options: options,
      );

      print('📘 Status Code: ${response.statusCode}');

      final responseString = jsonEncode(response.data);

      const chunkSize = 800;

      for (int i = 0; i < responseString.length; i += chunkSize) {
        print(
          responseString.substring(
            i,
            i + chunkSize > responseString.length
                ? responseString.length
                : i + chunkSize,
          ),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendanceReportResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e, stacktrace) {
      print('');
      print('==========================================');
      print('❌ ATTENDANCE REPORT DIO ERROR');
      print('==========================================');
      print('Message       : ${e.message}');
      print('Status Code   : ${e.response?.statusCode}');
      print('URL           : ${e.requestOptions.uri}');
      print('Request Data  : ${e.requestOptions.data}');
      print('Response Data : ${e.response?.data}');
      print('==========================================');

      print('📋 REQUEST BODY');
      print('------------------------------------------');
      print(jsonEncode(e.requestOptions.data));

      print('📋 SERVER RESPONSE');
      print('------------------------------------------');
      print(jsonEncode(e.response?.data));

      print('==========================================');
      print('📍 STACK TRACE');
      print('==========================================');
      print(stacktrace);
      print('==========================================');

      rethrow;
    } catch (e, stacktrace) {
      print('');
      print('==========================================');
      print('❌ EXCEPTION IN FETCH ATTENDANCE REPORT');
      print('==========================================');
      print('Error: $e');
      print('StackTrace: $stacktrace');
      print('==========================================');

      rethrow;
    }
  }

  @override
  Future<StudentAttendanceResponseModel> fetchStudentAttendance(
    int studentId,
  ) async {
    print('📘 Fetch Student Attendance Called');
    print('📌 Student ID: $studentId');

    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final basePath = ApiConstants.getStudentAttendancePath(baseUrl);

      // Append ID to URL
      final url = '$basePath$studentId';

      print('📘 URL: $url');

      final options = await ApiHelper.getAuthOptions(withToken: true);

      // No body
      final response = await dio.get(url, options: options);

      print('📘 Status Code: ${response.statusCode}');
      print('📘 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StudentAttendanceResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Exception in fetchStudentAttendance: $e');
      print(stackTrace);
      rethrow;
    }
  }
  // @override
  // Future<StudentAttendanceResponseModel> fetchStudentAttendance(
  //   int studentId,
  // ) async {
  //   print('📘 Fetch Student Attendance Called');
  //   print('📌 Student ID: $studentId');

  //   try {
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception("Base URL not set");
  //     }

  //     final url = ApiConstants.getStudentAttendancePath(baseUrl);

  //     print('📘 URL: $url');

  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     final requestData = {'studentId': studentId};

  //     print('📦 Request: $requestData');

  //     final response = await dio.get(url, data: requestData, options: options);

  //     print('📘 Status Code: ${response.statusCode}');
  //     print('📘 Response Data: ${response.data}');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return StudentAttendanceResponseModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     print('❌ Exception in fetchStudentAttendance: $e');
  //     print(stackTrace);
  //     rethrow;
  //   }
  // }

  @override
  Future<MasterResponseModel> updateStudentAttendance(
    int studentAttendanceMasterId,
    UpdateStudentAttendanceParameter params,
  ) async {
    print('✏️ Update Student Attendance Called');
    print('📌 Student Attendance ID: $studentAttendanceMasterId');
    print('UpdateStudentAttendanceParameter: ${params.toJson()}');

    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url =
          '${ApiConstants.getUpdateStudentAttendancePath(baseUrl)}'
          '$studentAttendanceMasterId';

      print("✏️ Update Student Attendance URL: $url");

      final options = await ApiHelper.getAuthOptions(withToken: true);

      final response = await dio.post(
        url,
        data: params.toJson(),
        options: options,
      );

      print('✏️ Status Code: ${response.statusCode}');

      final responseString = jsonEncode(response.data);

      const chunkSize = 800;

      for (int i = 0; i < responseString.length; i += chunkSize) {
        print(
          responseString.substring(
            i,
            i + chunkSize > responseString.length
                ? responseString.length
                : i + chunkSize,
          ),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception in updateStudentAttendance: $e');
      print(stacktrace);
      rethrow;
    }
  }
  @override
  Future<MonthlyAttendanceModel> fetchMonthlyAttendance(MonthlyAttendanceRequest request)
  async {
    print('✏️ Monthly Student Attendance Called');
    print('MonthlyAttendanceRequest: ${request.toJson()}');

    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url =
          '${ApiConstants.getMonthlyAttendancePath(baseUrl)}';

      print("✏️ Update Student Attendance URL: $url");

      final options = await ApiHelper.getAuthOptions(withToken: true);

      final response = await dio.post(
        url,
        data: request.toJson(),
        options: options,
      );

      print('✏️ Status Code: ${response.statusCode}');

      final responseString = jsonEncode(response.data);

      const chunkSize = 800;

      for (int i = 0; i < responseString.length; i += chunkSize) {
        print(
          responseString.substring(
            i,
            i + chunkSize > responseString.length
                ? responseString.length
                : i + chunkSize,
          ),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MonthlyAttendanceModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception in updateStudentAttendance: $e');
      print(stacktrace);
      rethrow;
    }
  }
}
