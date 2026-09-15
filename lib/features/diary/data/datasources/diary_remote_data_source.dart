import 'dart:convert';

import 'package:cristalteacher/core/errors/error_messege_model.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/network/api_endpoints.dart';
import 'package:cristalteacher/core/network/api_helper.dart';
import 'package:cristalteacher/features/diary/data/models/diary_model.dart';
import 'package:cristalteacher/features/diary/data/models/diary_update_listing_model.dart';
import 'package:cristalteacher/features/diary/domain/parameters/fetch_diary_parameter.dart';
import 'package:cristalteacher/features/diary/domain/parameters/save_diary_parameter.dart';
import 'package:cristalteacher/features/diary/domain/parameters/update_diary_parameter.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class DiaryRemoteDataSource {
  Future<DiaryResponseModel> fetchDiary(FetchDiaryParameter request);
  Future<MasterResponseModel> saveDiary(SaveDiaryParameter params);
  Future<MasterResponseModel> deleteDiary(int id);
  Future<DiaryUpdateListingResponseModel> fetchDiaryUpdateListing(int diaryId);
  Future<MasterResponseModel> updateDiary(
    int diaryId,
    UpdateDiaryParameter params,
  );
}

class DiaryRemoteDataSourceImpl implements DiaryRemoteDataSource {
  final Dio dio = Dio();
  @override
  Future<DiaryResponseModel> fetchDiary(FetchDiaryParameter request) async {
    print('');
    print('==============================================');
    print('📘 FETCH DIARY API START');
    print('==============================================');

    try {
      /// Shared Preference Values
      final pref = SharedPreferenceHelper();

      final baseUrl = await pref.getBaseUrl();
      final token = await pref.getToken();
      final dbName = await pref.getDatabaseName();

      print('📌 Shared Preference Values');
      print('----------------------------------------------');
      print('Base URL        : $baseUrl');
      print('Token           : $token');
      print('Database Name   : $dbName');
      print('----------------------------------------------');

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      /// API URL
      final url = ApiConstants.getDiaryDetailsPath(baseUrl);

      print('📌 API URL');
      print('----------------------------------------------');
      print(url);
      print('----------------------------------------------');

      /// Headers
      final options = await ApiHelper.getAuthOptions(withToken: true);

      print('📌 Request Headers');
      print('----------------------------------------------');
      options.headers?.forEach((key, value) {
        print('$key : $value');
      });
      print('----------------------------------------------');

      /// Request Body
      print('📌 Request Body');
      print('----------------------------------------------');
      print(request.toJson());

      print('branchId    : ${request.branchId}');
      print('standardId  : ${request.standardId}');
      print('divisionId  : ${request.divisionId}');
      print('accyear     : ${request.accyear}');
      print('fromDate    : ${request.fromDate}');
      print('toDate      : ${request.toDate}');
      print('userId      : ${request.userId}');
      print('----------------------------------------------');
      print("Content-Type: ${options.contentType}");
      print("Request Headers: ${options.headers}");
      print("Request Data Type: ${request.toJson().runtimeType}");

      /// API Call
      final response = await dio.post(
        url,
        data: request.toJson(),
        options: options,
      );

      print('📌 Response');
      print('----------------------------------------------');
      print('HTTP Status : ${response.statusCode}');
      print(response.data);
      print('----------------------------------------------');

      if (response.data is Map<String, dynamic>) {
        final json = response.data as Map<String, dynamic>;

        print('📌 Parsed Response');
        print('----------------------------------------------');
        print('status  : ${json['status']}');
        print('error   : ${json['error']}');
        print('message : ${json['message']}');

        if (json.containsKey('data')) {
          if (json['data'] is List) {
            final list = json['data'] as List;

            print('Data Count : ${list.length}');

            if (list.isNotEmpty) {
              print('First Item');
              print(list.first);
            }
          } else {
            print('Data');
            print(json['data']);
          }
        }

        print('----------------------------------------------');
      }

      print('==============================================');
      print('📘 FETCH DIARY API END');
      print('==============================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DiaryResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      print('📸 ================= FILE DEBUG =================');
      print('📸 Full Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];

        if (data is List) {
          for (var i = 0; i < data.length; i++) {
            print('📸 Diary $i files: ${data[i]['files']}');
            print('📸 Diary $i full item: ${data[i]}');
          }
        }
      }

      print('📸 ==============================================');
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    } on DioException catch (e, stackTrace) {
      print('');
      print('==============================================');
      print('❌ DIO EXCEPTION');
      print('==============================================');
      print('Message : ${e.message}');
      print('Status  : ${e.response?.statusCode}');
      print('Headers : ${e.response?.headers}');
      print('Response: ${e.response?.data}');
      print('Request : ${e.requestOptions.uri}');
      print('Method  : ${e.requestOptions.method}');
      print('==============================================');
      print(stackTrace);

      if (e.response?.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            e.response!.data as Map<String, dynamic>,
          ),
        );
      }

      rethrow;
    } catch (e, stackTrace) {
      print('');
      print('==============================================');
      print('❌ GENERAL EXCEPTION');
      print('==============================================');
      print(e);
      print(stackTrace);
      print('==============================================');
      rethrow;
    }
  }

  // @override
  // Future<MasterResponseModel> saveDiary(SaveDiaryParameter params) async {
  //   print('');
  //   print('==========================================');
  //   print('🟢 SAVE DIARY START');
  //   print('==========================================');

  //   try {
  //     final pref = SharedPreferenceHelper();

  //     final baseUrl = await pref.getBaseUrl();
  //     final dbName = await pref.getDatabaseName();
  //     final token = await pref.getToken() ?? '';

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception('Base URL not set');
  //     }

  //     if (token.isEmpty) {
  //       throw Exception('Token missing! Please login again.');
  //     }

  //     final url = ApiConstants.getSaveDiaryPath(baseUrl);

  //     print('🟢 Base URL: $baseUrl');
  //     print('🟢 DB Name: $dbName');
  //     print('🟢 API URL: $url');

  //     // ============================================================
  //     // NORMAL FIELDS
  //     // ============================================================

  //     final Map<String, dynamic> data = {
  //       'AccYear': params.accYear,
  //       'StandardId': params.standardId,
  //       'DivisionId': params.divisionId,
  //       'SubjectId': params.subjectId,
  //       'EmployeeId': params.employeeId,
  //       'diaryType': params.diaryType,
  //       'diaryTitle': params.diaryTitle,
  //       'Description': params.description,
  //       'diaryDate': params.diaryDate,
  //       'dueDate': params.dueDate,
  //       'isActive': params.isActive,
  //       'isFavourite': params.isFavourite,
  //       'branchId': params.branchId,
  //       'CreatedUser': params.createdUser,
  //       'videoUrl': params.videoUrl,
  //     };

  //     print('🟢 ===== FORM FIELDS =====');

  //     data.forEach((key, value) {
  //       print('$key : $value');
  //     });

  //     // ============================================================
  //     // FORMDATA
  //     // ============================================================

  //     final formData = FormData.fromMap(data);

  //     // ============================================================
  //     // FILES
  //     // ============================================================

  //     print('');
  //     print('==========================================');
  //     print('🟡 PROCESSING FILES');
  //     print('==========================================');

  //     print('🟡 Files Found: ${params.files.length}');

  //     for (int i = 0; i < params.files.length; i++) {
  //       final fileString = params.files[i];

  //       if (fileString.isEmpty) {
  //         print('⚠️ File ${i + 1} is empty. Skipping.');
  //         continue;
  //       }

  //       print('');
  //       print('------------------------------------------');
  //       print('🟡 Processing File ${i + 1}');
  //       print('------------------------------------------');

  //       print('🟡 File Length: ${fileString.length}');

  //       String base64String = fileString;

  //       // DO NOT default to jpg
  //       String fileName = 'diary_file_${i + 1}';

  //       String? contentType;

  //       // ==========================================================
  //       // DATA URI
  //       // ==========================================================

  //       if (fileString.startsWith('data:')) {
  //         final commaIndex = fileString.indexOf(',');

  //         if (commaIndex == -1) {
  //           throw Exception('Invalid Base64 file format for file ${i + 1}');
  //         }

  //         final header = fileString.substring(0, commaIndex);

  //         base64String = fileString.substring(commaIndex + 1);

  //         print('🟡 File Header: $header');

  //         // ========================================================
  //         // IMAGES
  //         // ========================================================

  //         if (header.contains('image/jpeg')) {
  //           fileName = 'diary_file_${i + 1}.jpg';
  //           contentType = 'image/jpeg';
  //         } else if (header.contains('image/png')) {
  //           fileName = 'diary_file_${i + 1}.png';
  //           contentType = 'image/png';
  //         } else if (header.contains('image/webp')) {
  //           fileName = 'diary_file_${i + 1}.webp';
  //           contentType = 'image/webp';
  //         }
  //         // ========================================================
  //         // AUDIO
  //         // ========================================================
  //         else if (header.contains('audio/mpeg')) {
  //           fileName = 'diary_file_${i + 1}.mp3';
  //           contentType = 'audio/mpeg';
  //         } else if (header.contains('audio/mp3')) {
  //           fileName = 'diary_file_${i + 1}.mp3';
  //           contentType = 'audio/mpeg';
  //         } else if (header.contains('audio/mp4')) {
  //           fileName = 'diary_file_${i + 1}.m4a';
  //           contentType = 'audio/mp4';
  //         } else if (header.contains('audio/x-m4a')) {
  //           fileName = 'diary_file_${i + 1}.m4a';
  //           contentType = 'audio/x-m4a';
  //         } else if (header.contains('audio/wav')) {
  //           fileName = 'diary_file_${i + 1}.wav';
  //           contentType = 'audio/wav';
  //         } else if (header.contains('audio/x-wav')) {
  //           fileName = 'diary_file_${i + 1}.wav';
  //           contentType = 'audio/wav';
  //         } else if (header.contains('audio/aac')) {
  //           fileName = 'diary_file_${i + 1}.aac';
  //           contentType = 'audio/aac';
  //         } else if (header.contains('audio/ogg')) {
  //           fileName = 'diary_file_${i + 1}.ogg';
  //           contentType = 'audio/ogg';
  //         } else if (header.contains('audio/amr')) {
  //           fileName = 'diary_file_${i + 1}.amr';
  //           contentType = 'audio/amr';
  //         } else {
  //           throw Exception(
  //             'Unsupported file type.\n'
  //             'File: ${i + 1}\n'
  //             'Header: $header',
  //           );
  //         }
  //       } else {
  //         print('⚠️ No DATA URI header found.');

  //         print(
  //           '⚠️ The Base64 does not contain '
  //           'the file type information.',
  //         );

  //         // We don't assume JPG anymore.
  //         //
  //         // If the recorder sends raw Base64 without
  //         // "data:audio/...", the actual file type must
  //         // be supplied by the code creating params.files.
  //       }

  //       // ==========================================================
  //       // BASE64 → BYTES
  //       // ==========================================================

  //       final bytes = base64Decode(base64String);

  //       print('🟢 Decoded Bytes: ${bytes.length}');
  //       print('🟢 File Name: $fileName');
  //       print('🟢 Content Type: $contentType');

  //       // ==========================================================
  //       // ADD FILE TO FORMDATA
  //       // ==========================================================

  //       formData.files.add(
  //         MapEntry(
  //           'files[]',
  //           MultipartFile.fromBytes(
  //             bytes,
  //             filename: fileName,
  //             // contentType: contentType != null
  //             //     ? MediaType.parse(contentType)
  //             //     : null,
  //           ),
  //         ),
  //       );

  //       print('🟢 File added successfully');
  //     }

  //     // ============================================================
  //     // DEBUG FORMDATA
  //     // ============================================================

  //     print('');
  //     print('==========================================');
  //     print('🟢 FORMDATA FIELDS');
  //     print('==========================================');

  //     for (final field in formData.fields) {
  //       print('${field.key} : ${field.value}');
  //     }

  //     print('');
  //     print('==========================================');
  //     print('🟡 FORMDATA FILES');
  //     print('==========================================');

  //     for (final file in formData.files) {
  //       print(
  //         'Key: ${file.key} | '
  //         'Filename: ${file.value.filename} | '
  //         'ContentType: ${file.value.contentType}',
  //       );
  //     }

  //     // ============================================================
  //     // API OPTIONS
  //     // ============================================================

  //     final options = Options(
  //       contentType: 'multipart/form-data',
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //         'X-Database-Name': dbName,
  //       },
  //     );

  //     // ============================================================
  //     // API CALL
  //     // ============================================================

  //     print('');
  //     print('==========================================');
  //     print('🟢 CALLING SAVE DIARY API');
  //     print('==========================================');

  //     final response = await dio.post(url, data: formData, options: options);

  //     // ============================================================
  //     // RESPONSE
  //     // ============================================================

  //     print('');
  //     print('==========================================');
  //     print('🟢 SAVE DIARY RESPONSE');
  //     print('==========================================');

  //     print('Status Code: ${response.statusCode}');
  //     print('Response Data: ${response.data}');

  //     print('==========================================');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return MasterResponseModel.fromJson(response.data);
  //     }

  //     throw ServerException(
  //       errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //     );
  //   } on DioException catch (e, stackTrace) {
  //     print('');
  //     print('==========================================');
  //     print('❌ DIO ERROR');
  //     print('==========================================');

  //     print('Message : ${e.message}');
  //     print('Status  : ${e.response?.statusCode}');
  //     print('Response: ${e.response?.data}');
  //     print('URL     : ${e.requestOptions.uri}');

  //     print('==========================================');
  //     print(stackTrace);

  //     if (e.response?.data is Map<String, dynamic>) {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
  //       );
  //     }

  //     rethrow;
  //   } catch (e, stackTrace) {
  //     print('');
  //     print('==========================================');
  //     print('❌ ERROR IN SAVE DIARY');
  //     print('==========================================');

  //     print(e);
  //     print(stackTrace);

  //     print('==========================================');

  //     rethrow;
  //   }
  // }
  @override
  Future<MasterResponseModel> saveDiary(SaveDiaryParameter params) async {
    debugPrint('');
    debugPrint('==========================================');
    debugPrint('🟢 SAVE DIARY START');
    debugPrint('==========================================');

    try {
      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();
      final String? databaseName = await preference.getDatabaseName();
      final String? token = await preference.getToken();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      if (token == null || token.trim().isEmpty) {
        throw Exception('Token missing! Please login again.');
      }

      if (params.standardId.isEmpty) {
        throw Exception('Please select at least one class');
      }

      final String url = ApiConstants.getSaveDiaryPath(baseUrl);

      debugPrint('🟢 Base URL: $baseUrl');
      debugPrint('🟢 DB Name: $databaseName');
      debugPrint('🟢 API URL: $url');

      /*
     * Convert selected classes to:
     *
     * [
     *   {"StandardId":1,"DivisionId":1},
     *   {"StandardId":2,"DivisionId":3}
     * ]
     */
      final String standardDivisionJson = jsonEncode(
        params.standardId
            .map((DiaryStandardDivisionParameter item) => item.toJson())
            .toList(),
      );

      final FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('AccYear', params.accYear),
        MapEntry('StandardId', standardDivisionJson),
        MapEntry('SubjectId', params.subjectId.toString()),
        MapEntry('EmployeeId', params.employeeId.toString()),
        MapEntry('diaryType', params.diaryType),
        MapEntry('diaryTitle', params.diaryTitle),
        MapEntry('Description', params.description),
        MapEntry('diaryDate', params.diaryDate),
        MapEntry('dueDate', params.dueDate),
        MapEntry('isActive', params.isActive.toString()),
        MapEntry('isFavourite', params.isFavourite.toString()),
        MapEntry('branchId', params.branchId.toString()),
        MapEntry('CreatedUser', params.createdUser.toString()),
        MapEntry('videoUrl', params.videoUrl),
      ]);

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('🟢 FORM FIELDS');
      debugPrint('==========================================');

      for (final MapEntry<String, String> field in formData.fields) {
        debugPrint('${field.key}: ${field.value}');
      }

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('🟡 PROCESSING FILES');
      debugPrint('==========================================');
      debugPrint('🟡 Files Found: ${params.files.length}');

      for (int index = 0; index < params.files.length; index++) {
        final String fileString = params.files[index].trim();

        if (fileString.isEmpty) {
          debugPrint('⚠️ File ${index + 1} is empty. Skipping.');
          continue;
        }

        debugPrint('');
        debugPrint('------------------------------------------');
        debugPrint('🟡 Processing File ${index + 1}');
        debugPrint('------------------------------------------');
        debugPrint('🟡 File String Length: ${fileString.length}');

        String base64String;
        String fileName;
        String detectedContentType;

        if (!fileString.startsWith('data:')) {
          throw Exception(
            'File ${index + 1} does not contain its file type. '
            'The file must use a data URI such as '
            'data:image/jpeg;base64,...',
          );
        }

        final int commaIndex = fileString.indexOf(',');

        if (commaIndex == -1) {
          throw Exception('Invalid Base64 format for file ${index + 1}');
        }

        final String header = fileString.substring(0, commaIndex);

        base64String = fileString.substring(commaIndex + 1);

        debugPrint('🟡 File Header: $header');

        if (!header.contains(';base64')) {
          throw Exception('File ${index + 1} is not Base64 encoded');
        }

        if (header.contains('image/jpeg')) {
          fileName = 'diary_file_${index + 1}.jpg';
          detectedContentType = 'image/jpeg';
        } else if (header.contains('image/png')) {
          fileName = 'diary_file_${index + 1}.png';
          detectedContentType = 'image/png';
        } else if (header.contains('image/webp')) {
          fileName = 'diary_file_${index + 1}.webp';
          detectedContentType = 'image/webp';
        } else if (header.contains('audio/mpeg') ||
            header.contains('audio/mp3')) {
          fileName = 'diary_file_${index + 1}.mp3';
          detectedContentType = 'audio/mpeg';
        } else if (header.contains('audio/mp4') ||
            header.contains('audio/x-m4a')) {
          fileName = 'diary_file_${index + 1}.m4a';
          detectedContentType = 'audio/mp4';
        } else if (header.contains('audio/wav') ||
            header.contains('audio/x-wav')) {
          fileName = 'diary_file_${index + 1}.wav';
          detectedContentType = 'audio/wav';
        } else if (header.contains('audio/aac')) {
          fileName = 'diary_file_${index + 1}.aac';
          detectedContentType = 'audio/aac';
        } else if (header.contains('audio/ogg')) {
          fileName = 'diary_file_${index + 1}.ogg';
          detectedContentType = 'audio/ogg';
        } else if (header.contains('audio/amr')) {
          fileName = 'diary_file_${index + 1}.amr';
          detectedContentType = 'audio/amr';
        } else if (header.contains('application/pdf')) {
          fileName = 'diary_file_${index + 1}.pdf';
          detectedContentType = 'application/pdf';
        } else if (header.contains('application/msword')) {
          fileName = 'diary_file_${index + 1}.doc';
          detectedContentType = 'application/msword';
        } else if (header.contains(
          'application/vnd.openxmlformats-officedocument'
          '.wordprocessingml.document',
        )) {
          fileName = 'diary_file_${index + 1}.docx';
          detectedContentType =
              'application/vnd.openxmlformats-officedocument'
              '.wordprocessingml.document';
        } else {
          throw Exception(
            'Unsupported file type for file ${index + 1}: '
            '$header',
          );
        }

        List<int> bytes;

        try {
          bytes = base64Decode(base64String.replaceAll(RegExp(r'\s'), ''));
        } on FormatException {
          throw Exception('Invalid Base64 content in file ${index + 1}');
        }

        if (bytes.isEmpty) {
          throw Exception('File ${index + 1} contains no data');
        }

        debugPrint('🟢 Decoded Bytes: ${bytes.length}');
        debugPrint('🟢 File Name: $fileName');
        debugPrint('🟢 Content Type: $detectedContentType');

        formData.files.add(
          MapEntry(
            'files[]',
            MultipartFile.fromBytes(bytes, filename: fileName),
          ),
        );

        debugPrint('🟢 File ${index + 1} added successfully');
      }

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('🟢 FINAL FORMDATA FIELDS');
      debugPrint('==========================================');

      for (final MapEntry<String, String> field in formData.fields) {
        debugPrint('${field.key}: ${field.value}');
      }

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('🟡 FINAL FORMDATA FILES');
      debugPrint('==========================================');

      if (formData.files.isEmpty) {
        debugPrint('ℹ️ No diary files added');
      }

      for (final MapEntry<String, MultipartFile> file in formData.files) {
        debugPrint(
          'Key: ${file.key} | '
          'Filename: ${file.value.filename} | '
          'Length: ${file.value.length} | '
          'ContentType: ${file.value.contentType}',
        );
      }

      final Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      if (databaseName != null && databaseName.trim().isNotEmpty) {
        headers['X-Database-Name'] = databaseName;
      }

      final Options options = Options(headers: headers);

      // Let Dio generate the multipart content type and boundary.
      options.contentType = null;
      options.headers?.remove('Content-Type');
      options.headers?.remove('content-type');

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('🟢 CALLING SAVE DIARY API');
      debugPrint('==========================================');

      final Response<dynamic> response = await dio.post<dynamic>(
        url,
        data: formData,
        options: options,
        onSendProgress: (int sent, int total) {
          if (total <= 0) return;

          final double percentage = (sent / total) * 100;

          debugPrint(
            '📤 Upload: '
            '${percentage.toStringAsFixed(1)}% '
            '($sent/$total bytes)',
          );
        },
      );

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('🟢 SAVE DIARY RESPONSE');
      debugPrint('==========================================');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
      debugPrint('==========================================');

      final dynamic responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid Save Diary API response: $responseData');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error, stackTrace) {
      final dynamic responseData = error.response?.data;

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('❌ SAVE DIARY DIO ERROR');
      debugPrint('==========================================');
      debugPrint('Message : ${error.message}');
      debugPrint('Status  : ${error.response?.statusCode}');
      debugPrint('Response: $responseData');
      debugPrint('URL     : ${error.requestOptions.uri}');

      final dynamic failedRequestData = error.requestOptions.data;

      if (failedRequestData is FormData) {
        debugPrint('');
        debugPrint('📋 FAILED REQUEST FIELDS');
        debugPrint('------------------------------------------');

        for (final MapEntry<String, String> field in failedRequestData.fields) {
          debugPrint('${field.key}: ${field.value}');
        }

        debugPrint('');
        debugPrint('📁 FAILED REQUEST FILES');
        debugPrint('------------------------------------------');

        for (final MapEntry<String, MultipartFile> file
            in failedRequestData.files) {
          debugPrint('${file.key}: ${file.value.filename}');
        }
      }

      debugPrintStack(stackTrace: stackTrace);
      debugPrint('==========================================');

      if (responseData is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseData),
        );
      }

      throw Exception(error.message ?? 'Unable to save diary');
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('==========================================');
      debugPrint('❌ ERROR IN SAVE DIARY');
      debugPrint('==========================================');
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      debugPrint('==========================================');

      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> deleteDiary(int id) async {
    print('');
    print('==========================================');
    print('🔴 DELETE DIARY START');
    print('==========================================');

    try {
      final pref = SharedPreferenceHelper();

      final baseUrl = await pref.getBaseUrl();
      final token = await pref.getToken() ?? '';
      final dbName = await pref.getDatabaseName();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('Base URL not set');
      }

      if (token.isEmpty) {
        throw Exception('Token missing! Please login again.');
      }

      final url = '${ApiConstants.deleteDiaryPath(baseUrl)}$id';

      print('🔴 Diary ID: $id');
      print('');
      print('🔴 DELETE DIARY URL');
      print('------------------------------------------');
      print(url);
      print('------------------------------------------');

      final options = Options(
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Database-Name': dbName,
        },
      );

      print('');
      print('🔴 REQUEST HEADERS');
      print('------------------------------------------');
      print(options.headers);
      print('------------------------------------------');

      print('');
      print('==========================================');
      print('🔴 CALLING DELETE DIARY API');
      print('==========================================');

      // IMPORTANT:
      // Backend supports GET, not POST.
      final response = await dio.get(url, options: options);

      print('');
      print('==========================================');
      print('🔴 DELETE DIARY RESPONSE');
      print('==========================================');

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.data}');

      print('==========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e, stackTrace) {
      print('');
      print('==========================================');
      print('❌ DELETE DIARY DIO ERROR');
      print('==========================================');

      print('Message  : ${e.message}');
      print('Status   : ${e.response?.statusCode}');
      print('Response : ${e.response?.data}');
      print('URL      : ${e.requestOptions.uri}');
      print('Method   : ${e.requestOptions.method}');

      print('==========================================');
      print(stackTrace);

      if (e.response?.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            e.response!.data as Map<String, dynamic>,
          ),
        );
      }

      rethrow;
    } catch (e, stackTrace) {
      print('');
      print('==========================================');
      print('❌ DELETE DIARY ERROR');
      print('==========================================');

      print(e);
      print(stackTrace);

      print('==========================================');

      rethrow;
    }
  }

  @override
  Future<DiaryUpdateListingResponseModel> fetchDiaryUpdateListing(
    int diaryId,
  ) async {
    print('');
    print('==========================================');
    print('📘 FETCH DIARY UPDATE LISTING START');
    print('==========================================');

    try {
      final pref = SharedPreferenceHelper();

      final String? baseUrl = await pref.getBaseUrl();
      final String token = await pref.getToken() ?? '';
      final String? dbName = await pref.getDatabaseName();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('Base URL not set');
      }

      if (token.isEmpty) {
        throw Exception('Token missing! Please login again.');
      }

      if (diaryId <= 0) {
        throw Exception('Invalid diary ID');
      }

      final String url =
          '${ApiConstants.getDiaryUpdateListingPath(baseUrl)}/$diaryId';

      print('Diary ID : $diaryId');
      print('API URL  : $url');

      final Options options = Options(
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Database-Name': dbName,
        },
      );

      print('Headers: ${options.headers}');

      // GET API:
      // No data and no queryParameters are passed.
      final Response<dynamic> response = await dio.get(url, options: options);

      print('');
      print('==========================================');
      print('📘 FETCH DIARY UPDATE LISTING RESPONSE');
      print('==========================================');
      print('Status Code : ${response.statusCode}');
      print('Response    : ${response.data}');
      print('==========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is! Map) {
          throw Exception('Invalid API response format');
        }

        return DiaryUpdateListingResponseModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (e, stackTrace) {
      print('');
      print('==========================================');
      print('❌ FETCH DIARY UPDATE LISTING DIO ERROR');
      print('==========================================');
      print('Message  : ${e.message}');
      print('Status   : ${e.response?.statusCode}');
      print('Response : ${e.response?.data}');
      print('URL      : ${e.requestOptions.uri}');
      print('Method   : ${e.requestOptions.method}');
      print(stackTrace);
      print('==========================================');

      if (e.response?.data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(e.response!.data as Map),
          ),
        );
      }

      rethrow;
    } catch (e, stackTrace) {
      print('');
      print('==========================================');
      print('❌ FETCH DIARY UPDATE LISTING ERROR');
      print('==========================================');
      print(e);
      print(stackTrace);
      print('==========================================');

      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> updateDiary(
    int diaryId,
    UpdateDiaryParameter params,
  ) async {
    print('');
    print('==========================================');
    print('🟠 UPDATE DIARY START');
    print('==========================================');

    try {
      final pref = SharedPreferenceHelper();

      final String? baseUrl = await pref.getBaseUrl();
      final String token = await pref.getToken() ?? '';
      final String? dbName = await pref.getDatabaseName();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('Base URL not set');
      }

      if (token.isEmpty) {
        throw Exception('Token missing! Please login again.');
      }

      if (diaryId <= 0) {
        throw Exception('Invalid diary ID');
      }

      // Change this endpoint method name according to your ApiConstants.
      final String url = '${ApiConstants.getUpdateDiaryPath(baseUrl)}/$diaryId';

      print('🟠 Diary ID : $diaryId');
      print('🟠 Base URL : $baseUrl');
      print('🟠 DB Name  : $dbName');
      print('🟠 API URL  : $url');

      // ============================================================
      // NORMAL FORM FIELDS
      // ============================================================

      final Map<String, dynamic> data = {
        'AccYear': params.accYear,
        'StandardId': params.standardId,
        'DivisionId': params.divisionId,
        'SubjectId': params.subjectId,
        'EmployeeId': params.employeeId,
        'diaryType': params.diaryType,
        'diaryTitle': params.diaryTitle,
        'Description': params.description,
        'diaryDate': params.diaryDate,
        'dueDate': params.dueDate,
        'isActive': params.isActive,
        'isFavourite': params.isFavourite,
        'branchId': params.branchId,
        'ModifiedUser': params.modifiedUser,
        'videoUrl': params.videoUrl,
      };

      print('');
      print('==========================================');
      print('🟠 UPDATE FORM FIELDS');
      print('==========================================');

      data.forEach((key, value) {
        print('$key : $value');
      });

      final FormData formData = FormData.fromMap(data);

      // ============================================================
      // FILES
      // ============================================================

      print('');
      print('==========================================');
      print('🟡 PROCESSING UPDATE FILES');
      print('==========================================');
      print('Files Found: ${params.files.length}');

      for (int i = 0; i < params.files.length; i++) {
        final String fileString = params.files[i];

        if (fileString.trim().isEmpty) {
          print('⚠️ File ${i + 1} is empty. Skipping.');
          continue;
        }

        String base64String = fileString;
        String fileName = 'diary_file_${i + 1}';

        if (fileString.startsWith('data:')) {
          final int commaIndex = fileString.indexOf(',');

          if (commaIndex == -1) {
            throw Exception('Invalid Base64 file format for file ${i + 1}');
          }

          final String header = fileString.substring(0, commaIndex);
          base64String = fileString.substring(commaIndex + 1);

          print('🟡 File ${i + 1} Header: $header');

          if (header.contains('image/jpeg')) {
            fileName = 'diary_file_${i + 1}.jpg';
          } else if (header.contains('image/png')) {
            fileName = 'diary_file_${i + 1}.png';
          } else if (header.contains('image/webp')) {
            fileName = 'diary_file_${i + 1}.webp';
          } else if (header.contains('audio/mpeg') ||
              header.contains('audio/mp3')) {
            fileName = 'diary_file_${i + 1}.mp3';
          } else if (header.contains('audio/mp4') ||
              header.contains('audio/x-m4a')) {
            fileName = 'diary_file_${i + 1}.m4a';
          } else if (header.contains('audio/wav') ||
              header.contains('audio/x-wav')) {
            fileName = 'diary_file_${i + 1}.wav';
          } else if (header.contains('audio/aac')) {
            fileName = 'diary_file_${i + 1}.aac';
          } else if (header.contains('audio/ogg')) {
            fileName = 'diary_file_${i + 1}.ogg';
          } else if (header.contains('audio/amr')) {
            fileName = 'diary_file_${i + 1}.amr';
          } else {
            throw Exception(
              'Unsupported file type.\n'
              'File: ${i + 1}\n'
              'Header: $header',
            );
          }
        } else {
          print(
            '⚠️ File ${i + 1} has no data URI header. '
            'Using the Base64 value directly.',
          );
        }

        try {
          final List<int> bytes = base64Decode(base64String);

          formData.files.add(
            MapEntry(
              'files[]',
              MultipartFile.fromBytes(bytes, filename: fileName),
            ),
          );

          print('🟢 File added: $fileName | Bytes: ${bytes.length}');
        } on FormatException {
          throw Exception('Invalid Base64 content for file ${i + 1}');
        }
      }

      // ============================================================
      // DEBUG FORMDATA
      // ============================================================

      print('');
      print('==========================================');
      print('🟠 UPDATE FORMDATA FIELDS');
      print('==========================================');

      for (final field in formData.fields) {
        print('${field.key} : ${field.value}');
      }

      print('');
      print('==========================================');
      print('🟠 UPDATE FORMDATA FILES');
      print('==========================================');

      for (final file in formData.files) {
        print(
          'Key: ${file.key} | '
          'Filename: ${file.value.filename} | '
          'ContentType: ${file.value.contentType}',
        );
      }

      final Options options = Options(
        contentType: 'multipart/form-data',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Database-Name': dbName,
        },
      );

      print('');
      print('==========================================');
      print('🟠 CALLING UPDATE DIARY API');
      print('==========================================');

      final Response<dynamic> response = await dio.post(
        url,
        data: formData,
        options: options,
      );

      print('');
      print('==========================================');
      print('🟠 UPDATE DIARY RESPONSE');
      print('==========================================');
      print('Status Code : ${response.statusCode}');
      print('Response    : ${response.data}');
      print('==========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is! Map) {
          throw Exception('Invalid update diary response format');
        }

        return MasterResponseModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }

      if (response.data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(response.data as Map),
          ),
        );
      }

      throw Exception('Update diary failed with status ${response.statusCode}');
    } on DioException catch (e, stackTrace) {
      print('');
      print('==========================================');
      print('❌ UPDATE DIARY DIO ERROR');
      print('==========================================');
      print('Message  : ${e.message}');
      print('Status   : ${e.response?.statusCode}');
      print('Response : ${e.response?.data}');
      print('URL      : ${e.requestOptions.uri}');
      print('Method   : ${e.requestOptions.method}');
      print(stackTrace);
      print('==========================================');

      if (e.response?.data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(e.response!.data as Map),
          ),
        );
      }

      rethrow;
    } catch (e, stackTrace) {
      print('');
      print('==========================================');
      print('❌ UPDATE DIARY ERROR');
      print('==========================================');
      print(e);
      print(stackTrace);
      print('==========================================');

      rethrow;
    }
  }
}
