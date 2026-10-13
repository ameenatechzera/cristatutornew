import 'dart:convert';
import 'dart:io';

import 'package:cristalteacher/core/errors/error_messege_model.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/network/api_endpoints.dart';
import 'package:cristalteacher/core/network/api_helper.dart';
import 'package:cristalteacher/features/feed/data/models/feed_updatelisting_model.dart';
import 'package:cristalteacher/features/feed/data/models/fetch_feed_model.dart';
import 'package:cristalteacher/features/feed/domain/parameters/fetch_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/parameters/save_feed_parameter.dart';
import 'package:cristalteacher/features/feed/domain/parameters/update_feed_parameter.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:dio/dio.dart';

abstract class FeedRemoteDataSource {
  Future<FetchFeedModel> fetchFeed(FetchFeedParams params);
  Future<MasterResponseModel> saveFeed(SaveFeedParameter params);
  Future<MasterResponseModel> deleteFeed(int feedId);
  Future<FeedUpdateListingModel> feedUpdateListing(int feedId);
  Future<MasterResponseModel> updateFeed(
    int feedId,
    UpdateFeedParameter params,
  );
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<FetchFeedModel> fetchFeed(FetchFeedParams params) async {
    print('📘 Fetch Feed Called');
    print('📘 Params: ${params.toJson()}');

    try {
      /// Base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      /// API URL
      final url = ApiConstants.getFeedReportPath(baseUrl);

      print("📘 URL => $url");

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
        return FetchFeedModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception in fetchFeed: $e');
      print(stacktrace);
      rethrow;
    }
  }

  // @override
  // Future<MasterResponseModel> saveFeed(SaveFeedParameter params) async {
  //   print('📘 Save Feed Called');
  //   print('📘 Params: ${params.toJson()}');

  //   try {
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception("Base URL not set");
  //     }

  //     final url = ApiConstants.getSaveFeedPath(baseUrl);

  //     print("📘 URL => $url");

  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     // ============================================================
  //     // CREATE FORM DATA
  //     // ============================================================

  //     final FormData formData = FormData();

  //     // ------------------------------------------------------------
  //     // NORMAL FIELDS
  //     // ------------------------------------------------------------

  //     formData.fields.add(MapEntry('feedText', params.feedText));

  //     formData.fields.add(MapEntry('feedTarget', params.feedTarget));

  //     formData.fields.add(MapEntry('userId', params.userId));

  //     formData.fields.add(MapEntry('branchId', params.branchId.toString()));

  //     formData.fields.add(MapEntry('CreatedUser', params.createdUser));

  //     formData.fields.add(MapEntry('AccYear', params.accYear.toString()));

  //     // ------------------------------------------------------------
  //     // STANDARD ID
  //     // ------------------------------------------------------------

  //     final String standardIdJson = jsonEncode(
  //       params.standardId.map((e) => e.toJson()).toList(),
  //     );

  //     formData.fields.add(MapEntry('StandardId', standardIdJson));

  //     // ============================================================
  //     // SINGLE FILE
  //     // ============================================================

  //     if (params.feedMasterFiles.isNotEmpty) {
  //       final String filePath = params.feedMasterFiles.first.file;

  //       final File file = File(filePath);

  //       if (!await file.exists()) {
  //         throw Exception('Selected file does not exist: $filePath');
  //       }

  //       final String fileName = filePath.split(Platform.pathSeparator).last;

  //       final int fileSize = await file.length();

  //       print('==========================================');
  //       print('📎 ADDING FILE');
  //       print('📎 Parameter: FeedMasterFiles');
  //       print('📎 File name: $fileName');
  //       print('📎 File path: $filePath');
  //       print('📎 File size: $fileSize bytes');
  //       print('==========================================');

  //       final MultipartFile multipartFile = await MultipartFile.fromFile(
  //         filePath,
  //         filename: fileName,
  //       );

  //       // IMPORTANT:
  //       // Backend expects SINGLE file.
  //       formData.files.add(MapEntry('FeedMasterFiles', multipartFile));
  //     }

  //     // ============================================================
  //     // DEBUG
  //     // ============================================================

  //     print('==========================================');
  //     print('📘 MULTIPART SAVE FEED REQUEST');
  //     print('📘 URL: $url');
  //     print('📘 feedText: ${params.feedText}');
  //     print('📘 feedTarget: ${params.feedTarget}');
  //     print('📘 userId: ${params.userId}');
  //     print('📘 branchId: ${params.branchId}');
  //     print('📘 CreatedUser: ${params.createdUser}');
  //     print('📘 AccYear: ${params.accYear}');
  //     print('📘 StandardId: $standardIdJson');
  //     print('📘 File attached: ${params.feedMasterFiles.isNotEmpty}');
  //     print('==========================================');

  //     // ============================================================
  //     // API CALL
  //     // ============================================================

  //     final response = await dio.post(url, data: formData, options: options);

  //     print('==========================================');
  //     print('📘 SAVE FEED RESPONSE');
  //     print('📘 Status Code: ${response.statusCode}');
  //     print('📘 Response: ${response.data}');
  //     print('==========================================');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return MasterResponseModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //       );
  //     }
  //   } catch (e, stacktrace) {
  //     print('❌ Exception in saveFeed: $e');
  //     print(stacktrace);

  //     if (e is DioException) {
  //       print('==========================================');
  //       print('❌ DIO ERROR');
  //       print('❌ Status Code: ${e.response?.statusCode}');
  //       print('❌ Response Data: ${e.response?.data}');
  //       print('❌ Response Headers: ${e.response?.headers}');
  //       print('==========================================');
  //     }

  //     rethrow;
  //   }
  // }
  @override
  Future<MasterResponseModel> saveFeed(SaveFeedParameter params) async {
    print('');
    print('==========================================');
    print('📘 SAVE FEED START');
    print('==========================================');

    Map<String, dynamic>? decodeResponse(dynamic data) {
      dynamic decoded = data;

      if (data is String) {
        try {
          decoded = jsonDecode(data);
        } on FormatException {
          return null;
        }
      }

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }

      return null;
    }

    try {
      final String? baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.getSaveFeedPath(baseUrl);

      final Options authOptions = await ApiHelper.getAuthOptions(
        withToken: true,
      );

      // Preserve authentication headers, allowing Dio to generate
      // the multipart Content-Type and boundary.
      final Map<String, dynamic> headers = Map<String, dynamic>.from(
        authOptions.headers ?? <String, dynamic>{},
      );

      headers.removeWhere((key, _) => key.toLowerCase() == 'content-type');

      final Options options = authOptions.copyWith(headers: headers);

      options.contentType = null;

      final String standardIdJson = jsonEncode(
        params.standardId.map((item) => item.toJson()).toList(),
      );

      final FormData formData = FormData();

      // Match the working request you supplied.
      formData.fields.addAll([
        MapEntry('feedText', params.feedText),
        MapEntry('feedTarget', params.feedTarget),
        const MapEntry('Status', '1'),
        MapEntry('AccYear', params.accYear.toString()),
        MapEntry('userId', params.userId.toString()),
        MapEntry('branchId', params.branchId.toString()),
        MapEntry('StandardId', standardIdJson),
        MapEntry('CreatedUser', params.createdUser.toString()),
        MapEntry('videoUrl', jsonEncode(<String>[])),
      ]);

      print('📘 Files received: ${params.feedMasterFiles.length}');

      for (int index = 0; index < params.feedMasterFiles.length; index++) {
        final item = params.feedMasterFiles[index];
        final File file = File(item.file);

        if (!await file.exists()) {
          throw Exception('Selected file does not exist: ${file.path}');
        }

        final int fileSize = await file.length();

        if (fileSize == 0) {
          throw Exception('Selected file is empty: ${file.path}');
        }

        final String fileName = file.uri.pathSegments.last;

        final MultipartFile multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );

        // Repeat this exact key for every file.
        // Do not use FeedMasterFiles[] or indexed keys.
        formData.files.add(
          MapEntry<String, MultipartFile>('FeedMasterFiles[]', multipartFile),
        );

        print('📎 File ${index + 1}: $fileName');
        print('📎 Field: FeedMasterFiles');
        print('📎 Size: $fileSize bytes');
      }

      print('');
      print('========== FINAL SAVE FEED REQUEST ==========');
      print('URL: $url');

      for (final field in formData.fields) {
        print('${field.key}: ${field.value}');
      }

      print('Total files attached: ${formData.files.length}');

      for (final entry in formData.files) {
        print(
          '${entry.key}: ${entry.value.filename} '
          '(${entry.value.length} bytes)',
        );
      }

      print('============================================');

      int lastProgressStep = -1;

      final Response<dynamic> response = await dio.post<dynamic>(
        url,
        data: formData,
        options: options,
        onSendProgress: (int sent, int total) {
          if (total <= 0) return;

          final int percentage = ((sent / total) * 100).clamp(0, 100).floor();

          final int progressStep = percentage ~/ 10;

          if (progressStep != lastProgressStep) {
            lastProgressStep = progressStep;

            print(
              '📤 Feed upload: $percentage% '
              '($sent/$total bytes)',
            );
          }
        },
      );

      print('');
      print('========== SAVE FEED RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
      print('========================================');

      final Map<String, dynamic>? responseJson = decodeResponse(response.data);

      if (responseJson == null) {
        throw const FormatException('Invalid Save Feed API response format');
      }

      final bool httpSuccess =
          response.statusCode == 200 || response.statusCode == 201;

      final dynamic rawStatus = responseJson['status'];
      final int? apiStatus = int.tryParse(rawStatus?.toString() ?? '');

      final String errorValue =
          responseJson['error']?.toString().toLowerCase() ?? '';

      final bool apiError = errorValue == 'true' || errorValue == '1';

      // This expects response status to be an HTTP-style API code.
      final bool apiStatusSuccess =
          rawStatus == null || apiStatus == 200 || apiStatus == 201;

      if (!httpSuccess || apiError || !apiStatusSuccess) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseJson),
        );
      }

      print('✅ Feed save request succeeded');

      return MasterResponseModel.fromJson(responseJson);
    } on DioException catch (error, stackTrace) {
      print('');
      print('========== SAVE FEED DIO ERROR ==========');
      print('Status Code: ${error.response?.statusCode}');
      print('Response: ${error.response?.data}');
      print('Message: ${error.message}');
      print(stackTrace);

      final Map<String, dynamic>? errorJson = decodeResponse(
        error.response?.data,
      );

      if (errorJson != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(errorJson),
        );
      }

      rethrow;
    } catch (error, stackTrace) {
      print('❌ SAVE FEED ERROR: $error');
      print(stackTrace);
      rethrow;
    }
  }
  // @override
  // Future<MasterResponseModel> saveFeed(SaveFeedParameter params) async {
  //   print('');
  //   print('==========================================');
  //   print('📘 SAVE FEED CALLED');
  //   print('==========================================');
  //   print('📘 Params: ${params.toJson()}');

  //   try {
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception("Base URL not set");
  //     }

  //     final url = ApiConstants.getSaveFeedPath(baseUrl);
  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     print('🌐 API URL: $url');

  //     // ============================================================
  //     // CREATE FORM DATA
  //     // ============================================================

  //     final FormData formData = FormData();

  //     // ============================================================
  //     // NORMAL FIELDS
  //     // ============================================================

  //     formData.fields.add(MapEntry('feedText', params.feedText));
  //     formData.fields.add(MapEntry('feedTarget', params.feedTarget));
  //     formData.fields.add(MapEntry('userId', params.userId));
  //     formData.fields.add(MapEntry('branchId', params.branchId.toString()));
  //     formData.fields.add(MapEntry('CreatedUser', params.createdUser));
  //     formData.fields.add(MapEntry('AccYear', params.accYear.toString()));

  //     // ============================================================
  //     // STANDARD ID
  //     // ============================================================

  //     final String standardIdJson = jsonEncode(
  //       params.standardId.map((e) => e.toJson()).toList(),
  //     );

  //     formData.fields.add(MapEntry('StandardId', standardIdJson));

  //     // ============================================================
  //     // DEBUG: FILES RECEIVED FROM UI
  //     // ============================================================

  //     print('');
  //     print('========== FILES RECEIVED FROM UI ==========');
  //     print('Total file parameters: ${params.feedMasterFiles.length}');

  //     for (int i = 0; i < params.feedMasterFiles.length; i++) {
  //       final item = params.feedMasterFiles[i];
  //       final File file = File(item.file);

  //       print('File ${i + 1}: ${item.file}');
  //       print('Exists: ${await file.exists()}');

  //       if (await file.exists()) {
  //         print('Size: ${await file.length()} bytes');
  //       }
  //     }

  //     print('============================================');

  //     // ============================================================
  //     // ATTACH MULTIPLE FILES
  //     // ============================================================

  //     for (int i = 0; i < params.feedMasterFiles.length; i++) {
  //       final item = params.feedMasterFiles[i];
  //       final String filePath = item.file;
  //       final File file = File(filePath);

  //       if (!await file.exists()) {
  //         throw Exception('Selected file does not exist: $filePath');
  //       }

  //       final String fileName = filePath.split(Platform.pathSeparator).last;

  //       final int fileSize = await file.length();

  //       final MultipartFile multipartFile = await MultipartFile.fromFile(
  //         filePath,
  //         filename: fileName,
  //       );

  //       formData.files.add(
  //         MapEntry<String, MultipartFile>('FeedMasterFiles', multipartFile),
  //       );

  //       print('');
  //       print('========== FILE ATTACHED ${i + 1} ==========');
  //       print('Field name: FeedMasterFiles');
  //       print('Filename: $fileName');
  //       print('File size: $fileSize bytes');
  //       print('============================================');
  //     }

  //     // ============================================================
  //     // VERIFY FINAL MULTIPART REQUEST
  //     // ============================================================

  //     print('');
  //     print('========== FINAL MULTIPART DEBUG ==========');
  //     print('URL: $url');
  //     print('feedText: ${params.feedText}');
  //     print('feedTarget: ${params.feedTarget}');
  //     print('userId: ${params.userId}');
  //     print('branchId: ${params.branchId}');
  //     print('CreatedUser: ${params.createdUser}');
  //     print('AccYear: ${params.accYear}');
  //     print('StandardId: $standardIdJson');

  //     print('Total files attached: ${formData.files.length}');

  //     for (int i = 0; i < formData.files.length; i++) {
  //       final entry = formData.files[i];

  //       print('Multipart file ${i + 1}:');
  //       print('  Field: ${entry.key}');
  //       print('  Filename: ${entry.value.filename}');
  //       print('  Length: ${entry.value.length} bytes');
  //     }

  //     print('============================================');

  //     // ============================================================
  //     // API CALL
  //     // ============================================================

  //     print('');
  //     print('📤 SENDING REQUEST TO API...');

  //     final response = await dio.post(url, data: formData, options: options);

  //     // ============================================================
  //     // SAVE RESPONSE
  //     // ============================================================

  //     print('');
  //     print('========== SAVE FEED API RESPONSE ==========');
  //     print('Status Code: ${response.statusCode}');
  //     print('Response: ${response.data}');
  //     print('============================================');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('✅ API ACCEPTED THE SAVE REQUEST');

  //       return MasterResponseModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(response.data),
  //       );
  //     }
  //   } catch (e, stacktrace) {
  //     print('');
  //     print('========== SAVE FEED EXCEPTION =============');
  //     print('Error: $e');
  //     print(stacktrace);

  //     if (e is DioException) {
  //       print('========== DIO ERROR DETAILS ==============');
  //       print('Status Code: ${e.response?.statusCode}');
  //       print('Response Data: ${e.response?.data}');
  //       print('Response Headers: ${e.response?.headers}');
  //       print('============================================');
  //     }

  //     rethrow;
  //   }
  // }

  @override
  Future<MasterResponseModel> deleteFeed(int feedId) async {
    print('📘 Delete Feed Called');
    print('📘 Feed ID: $feedId');

    try {
      /// Base URL
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      /// API URL
      final url = '${ApiConstants.getDeleteFeedPath(baseUrl)}$feedId';

      print("📘 URL => $url");

      /// Headers
      final options = await ApiHelper.getAuthOptions(withToken: true);

      /// API Call
      final response = await dio.get(
        url,
        data: {"feedId": feedId},
        options: options,
      );

      print('📘 Status Code: ${response.statusCode}');
      print('📘 Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stacktrace) {
      print('❌ Exception in deleteFeed: $e');
      print(stacktrace);
      rethrow;
    }
  }

  @override
  Future<FeedUpdateListingModel> feedUpdateListing(int feedId) async {
    print('📘 FEED UPDATE LISTING START');
    print('📘 Feed ID: $feedId');

    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('Base URL not set');
      }

      if (feedId <= 0) {
        throw Exception('Invalid feed ID');
      }

      // Remove trailing slashes before appending /feedId.
      final endpoint = ApiConstants.getFeedUpdateListingPath(
        baseUrl,
      ).replaceFirst(RegExp(r'/+$'), '');

      final String url = '$endpoint/$feedId';

      print('📘 API URL: $url');

      final options = await ApiHelper.getAuthOptions(withToken: true);

      // ID is passed in the URL.
      final response = await dio.get(url, options: options);

      print('📘 Status Code: ${response.statusCode}');
      print('📘 Response: ${response.data}');

      final dynamic decoded = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

      if (decoded is! Map) {
        throw const FormatException(
          'Invalid feed update listing response format',
        );
      }

      final responseJson = Map<String, dynamic>.from(decoded);

      final httpSuccess =
          response.statusCode == 200 || response.statusCode == 201;

      final apiStatus = int.tryParse(responseJson['status']?.toString() ?? '');

      final apiSuccess =
          responseJson['error'] != true &&
          (apiStatus == null || apiStatus == 200 || apiStatus == 201);

      if (!httpSuccess || !apiSuccess) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseJson),
        );
      }

      final dynamic data = responseJson['data'];

      if (data is! Map) {
        throw const FormatException(
          'Feed update listing data is missing or invalid',
        );
      }

      return FeedUpdateListingModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e, stackTrace) {
      print('❌ FEED UPDATE LISTING DIO ERROR');
      print('❌ Message: ${e.message}');
      print('❌ Status: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');
      print('❌ URL: ${e.requestOptions.uri}');
      print(stackTrace);

      final errorData = e.response?.data;

      if (errorData is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(errorData),
          ),
        );
      }

      rethrow;
    } catch (e, stackTrace) {
      print('❌ Exception in feedUpdateListing: $e');
      print(stackTrace);
      rethrow;
    }
  }

  // @override
  // Future<MasterResponseModel> updateFeed(
  //   int feedId,
  //   UpdateFeedParameter params,
  // ) async {
  //   print('📘 UPDATE FEED START');
  //   print('📘 Feed ID: $feedId');

  //   try {
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception('Base URL not set');
  //     }

  //     if (feedId <= 0) {
  //       throw Exception('Invalid feed ID');
  //     }

  //     final endpoint = ApiConstants.getUpdateFeedPath(
  //       baseUrl,
  //     ).replaceFirst(RegExp(r'/+$'), '');

  //     final String url = '$endpoint/$feedId';

  //     print('📘 API URL: $url');

  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     final String standardIdJson = jsonEncode(
  //       params.standardId.map((e) => e.toJson()).toList(),
  //     );

  //     final FormData formData = FormData();

  //     formData.fields.addAll([
  //       MapEntry('feedText', params.feedText),
  //       MapEntry('feedTarget', params.feedTarget),
  //       MapEntry('StandardId', standardIdJson),
  //       MapEntry('userId', params.userId),
  //       MapEntry('branchId', params.branchId.toString()),
  //       MapEntry('CreatedUser', params.createdUser),
  //       MapEntry('AccYear', params.accYear),
  //     ]);

  //     // Same single-file handling as saveFeed.
  //     if (params.feedMasterFiles.isNotEmpty) {
  //       final String filePath = params.feedMasterFiles.first.file;
  //       final File file = File(filePath);

  //       if (!await file.exists()) {
  //         throw Exception('Selected file does not exist: $filePath');
  //       }

  //       final String fileName = filePath.split(Platform.pathSeparator).last;
  //       final int fileSize = await file.length();

  //       print('📎 Parameter: FeedMasterFiles');
  //       print('📎 File name: $fileName');
  //       print('📎 File size: $fileSize bytes');

  //       final MultipartFile multipartFile = await MultipartFile.fromFile(
  //         filePath,
  //         filename: fileName,
  //       );

  //       formData.files.add(MapEntry('FeedMasterFiles', multipartFile));
  //     }

  //     print('📘 MULTIPART UPDATE FEED REQUEST');
  //     print('📘 Feed ID: $feedId');
  //     print('📘 URL: $url');

  //     for (final field in formData.fields) {
  //       print('📘 ${field.key}: ${field.value}');
  //     }

  //     print('📘 File count: ${formData.files.length}');

  //     // Let Dio generate the multipart boundary.
  //     final response = await dio.post(
  //       url,
  //       data: formData,
  //       options: options.copyWith(contentType: 'multipart/form-data'),
  //     );

  //     print('📘 UPDATE FEED RESPONSE');
  //     print('📘 Status Code: ${response.statusCode}');
  //     print('📘 Response: ${response.data}');

  //     final dynamic decoded = response.data is String
  //         ? jsonDecode(response.data as String)
  //         : response.data;

  //     if (decoded is! Map) {
  //       throw const FormatException('Invalid update feed response format');
  //     }

  //     final responseJson = Map<String, dynamic>.from(decoded);

  //     final bool httpSuccess =
  //         response.statusCode == 200 || response.statusCode == 201;

  //     final int? apiStatus = int.tryParse(
  //       responseJson['status']?.toString() ?? '',
  //     );

  //     final bool apiSuccess =
  //         responseJson['error'] != true &&
  //         (apiStatus == null || apiStatus == 200 || apiStatus == 201);

  //     if (!httpSuccess || !apiSuccess) {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(responseJson),
  //       );
  //     }

  //     return MasterResponseModel.fromJson(responseJson);
  //   } on DioException catch (e, stackTrace) {
  //     print('❌ UPDATE FEED DIO ERROR');
  //     print('❌ Message: ${e.message}');
  //     print('❌ Status Code: ${e.response?.statusCode}');
  //     print('❌ Response: ${e.response?.data}');
  //     print('❌ URL: ${e.requestOptions.uri}');
  //     print('❌ Method: ${e.requestOptions.method}');
  //     print(stackTrace);

  //     final dynamic rawError = e.response?.data;

  //     dynamic decodedError = rawError;

  //     if (rawError is String) {
  //       try {
  //         decodedError = jsonDecode(rawError);
  //       } on FormatException {
  //         decodedError = null;
  //       }
  //     }

  //     if (decodedError is Map) {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(
  //           Map<String, dynamic>.from(decodedError),
  //         ),
  //       );
  //     }

  //     rethrow;
  //   } catch (e, stackTrace) {
  //     print('❌ Exception in updateFeed: $e');
  //     print(stackTrace);
  //     rethrow;
  //   }
  // }
  @override
  Future<MasterResponseModel> updateFeed(
    int feedId,
    UpdateFeedParameter params,
  ) async {
    print('📘 UPDATE FEED START');
    print('📘 Feed ID: $feedId');

    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('Base URL not set');
      }

      if (feedId <= 0) {
        throw Exception('Invalid feed ID');
      }

      final String url = '${ApiConstants.getUpdateFeedPath(baseUrl)}/$feedId';

      print('📘 API URL: $url');

      final options = await ApiHelper.getAuthOptions(withToken: true);

      final String standardIdJson = jsonEncode(
        params.standardId.map((e) => e.toJson()).toList(),
      );

      final FormData formData = FormData();

      // Request fields matching the update API.
      formData.fields.addAll([
        MapEntry('feedText', params.feedText),
        MapEntry('feedTarget', params.feedTarget),
        MapEntry('Status', params.status.toString()),
        MapEntry('AccYear', params.accYear),
        MapEntry('userId', params.userId),
        MapEntry('branchId', params.branchId.toString()),
        MapEntry('StandardId', standardIdJson),
        MapEntry('ModifiedUser', params.modifiedUser),
        MapEntry('videoUrl', jsonEncode(params.videoUrl)),
      ]);

      // CHANGED: send existing files as a real array (existingFiles[]),
      // not a JSON string, so Laravel receives a PHP array.
      for (final dynamic fileUrl in params.existingFiles) {
        final String value = fileUrl.toString().trim();

        if (value.isNotEmpty) {
          formData.fields.add(MapEntry('existingFiles[]', value));
        }
      }

      // Upload newly selected files using the confirmed field name.
      for (final FeedMasterFileParameter item in params.feedMasterFiles) {
        final String filePath = item.file;
        final File file = File(filePath);

        if (!await file.exists()) {
          throw Exception('Selected file does not exist: $filePath');
        }

        final String fileName = file.uri.pathSegments.last;

        final int fileSize = await file.length();

        if (fileSize == 0) {
          throw Exception('Selected file is empty: $filePath');
        }

        print('📎 Parameter: FeedMasterFiles[]');
        print('📎 File name: $fileName');
        print('📎 File path: $filePath');
        print('📎 File size: $fileSize bytes');

        final MultipartFile multipartFile = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );

        formData.files.add(
          MapEntry<String, MultipartFile>('FeedMasterFiles[]', multipartFile),
        );

        print('✅ Added file: $fileName');
      }

      print('');
      print('========== UPDATE FEED REQUEST ==========');
      print('Feed ID: $feedId');
      print('URL: $url');

      for (final field in formData.fields) {
        print('${field.key}: ${field.value}');
      }

      print('FeedMasterFiles[] (${formData.files.length} files):');

      for (final entry in formData.files) {
        print(
          '  - ${entry.value.filename} '
          '(${entry.value.length} bytes)',
        );
      }

      print('=========================================');

      final response = await dio.post(url, data: formData, options: options);
      print('========== ACTUAL UPDATE REQUEST ==========');
      print('Method: ${response.requestOptions.method}');
      print('URL: ${response.requestOptions.uri}');
      print('Content-Type: ${response.requestOptions.contentType}');

      final sentData = response.requestOptions.data;

      if (sentData is FormData) {
        for (final field in sentData.fields) {
          print('${field.key}: ${field.value}');
        }

        print('Uploaded files: ${sentData.files.length}');
      }

      print('==========================================');
      print('');
      print('========== UPDATE FEED RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
      print('==========================================');

      final dynamic decoded = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

      if (decoded is! Map) {
        throw const FormatException('Invalid update feed response format');
      }

      final responseJson = Map<String, dynamic>.from(decoded);

      final bool httpSuccess =
          response.statusCode == 200 || response.statusCode == 201;

      final int? apiStatus = int.tryParse(
        responseJson['status']?.toString() ?? '',
      );

      final String errorValue =
          responseJson['error']?.toString().toLowerCase() ?? '';

      final bool apiError = errorValue == 'true' || errorValue == '1';

      final bool apiSuccess =
          !apiError &&
          (apiStatus == null || apiStatus == 200 || apiStatus == 201);

      if (!httpSuccess || !apiSuccess) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseJson),
        );
      }

      print('✅ Feed update succeeded');

      return MasterResponseModel.fromJson(responseJson);
    } on DioException catch (e, stackTrace) {
      print('❌ UPDATE FEED DIO ERROR');
      print('❌ Message: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');
      print('❌ URL: ${e.requestOptions.uri}');
      print('❌ Method: ${e.requestOptions.method}');
      print(stackTrace);

      final dynamic rawError = e.response?.data;
      dynamic decodedError = rawError;

      if (rawError is String) {
        try {
          decodedError = jsonDecode(rawError);
        } on FormatException {
          decodedError = null;
        }
      }

      if (decodedError is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(decodedError),
          ),
        );
      }

      rethrow;
    } catch (e, stackTrace) {
      print('❌ Exception in updateFeed: $e');
      print(stackTrace);
      rethrow;
    }
  }

  // @override
  // Future<MasterResponseModel> updateFeed(
  //   int feedId,
  //   UpdateFeedParameter params,
  // ) async {
  //   print('📘 UPDATE FEED START');
  //   print('📘 Feed ID: $feedId');

  //   try {
  //     final baseUrl = await SharedPreferenceHelper().getBaseUrl();

  //     if (baseUrl == null || baseUrl.isEmpty) {
  //       throw Exception('Base URL not set');
  //     }

  //     if (feedId <= 0) {
  //       throw Exception('Invalid feed ID');
  //     }

  //     final String url = '${ApiConstants.getUpdateFeedPath(baseUrl)}/$feedId';

  //     print('📘 API URL: $url');

  //     final options = await ApiHelper.getAuthOptions(withToken: true);

  //     final String standardIdJson = jsonEncode(
  //       params.standardId.map((e) => e.toJson()).toList(),
  //     );

  //     final FormData formData = FormData();

  //     formData.fields.addAll([
  //       MapEntry('feedText', params.feedText),
  //       MapEntry('feedTarget', params.feedTarget),
  //       MapEntry('StandardId', standardIdJson),
  //       MapEntry('userId', params.userId),
  //       MapEntry('branchId', params.branchId.toString()),
  //       MapEntry('CreatedUser', params.createdUser),
  //       MapEntry('AccYear', params.accYear),
  //     ]);

  //     // Upload all newly selected files.
  //     // Existing server attachments are not re-uploaded.
  //     for (final FeedMasterFileParameter item in params.feedMasterFiles) {
  //       final String filePath = item.file;
  //       final File file = File(filePath);

  //       if (!await file.exists()) {
  //         throw Exception('Selected file does not exist: $filePath');
  //       }

  //       final String fileName = filePath.split(Platform.pathSeparator).last;

  //       final int fileSize = await file.length();

  //       print('📎 Parameter: FeedMasterFiles');
  //       print('📎 File name: $fileName');
  //       print('📎 File path: $filePath');
  //       print('📎 File size: $fileSize bytes');

  //       final MultipartFile multipartFile = await MultipartFile.fromFile(
  //         filePath,
  //         filename: fileName,
  //       );

  //       formData.files.add(MapEntry('FeedMasterFiles[]', multipartFile));

  //       print('✅ Added file: $fileName');
  //     }

  //     print('📘 MULTIPART UPDATE FEED REQUEST');
  //     print('📘 Feed ID: $feedId');
  //     print('📘 URL: $url');

  //     for (final field in formData.fields) {
  //       print('📘 ${field.key}: ${field.value}');
  //     }

  //     print('📘 File count: ${formData.files.length}');

  //     for (final entry in formData.files) {
  //       print('📘 Uploaded field: ${entry.key}');
  //       print('📘 Uploaded filename: ${entry.value.filename}');
  //     }

  //     final response = await dio.post(
  //       url,
  //       data: formData,
  //       options: options.copyWith(contentType: 'multipart/form-data'),
  //     );

  //     print('📘 UPDATE FEED RESPONSE');
  //     print('📘 Status Code: ${response.statusCode}');
  //     print('📘 Response: ${response.data}');

  //     final dynamic decoded = response.data is String
  //         ? jsonDecode(response.data as String)
  //         : response.data;

  //     if (decoded is! Map) {
  //       throw const FormatException('Invalid update feed response format');
  //     }

  //     final responseJson = Map<String, dynamic>.from(decoded);

  //     final bool httpSuccess =
  //         response.statusCode == 200 || response.statusCode == 201;

  //     final int? apiStatus = int.tryParse(
  //       responseJson['status']?.toString() ?? '',
  //     );

  //     final bool apiSuccess =
  //         responseJson['error'] != true &&
  //         (apiStatus == null || apiStatus == 200 || apiStatus == 201);

  //     if (!httpSuccess || !apiSuccess) {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(responseJson),
  //       );
  //     }

  //     return MasterResponseModel.fromJson(responseJson);
  //   } on DioException catch (e, stackTrace) {
  //     print('❌ UPDATE FEED DIO ERROR');
  //     print('❌ Message: ${e.message}');
  //     print('❌ Status Code: ${e.response?.statusCode}');
  //     print('❌ Response: ${e.response?.data}');
  //     print('❌ URL: ${e.requestOptions.uri}');
  //     print('❌ Method: ${e.requestOptions.method}');
  //     print(stackTrace);

  //     final dynamic rawError = e.response?.data;
  //     dynamic decodedError = rawError;

  //     if (rawError is String) {
  //       try {
  //         decodedError = jsonDecode(rawError);
  //       } on FormatException {
  //         decodedError = null;
  //       }
  //     }

  //     if (decodedError is Map) {
  //       throw ServerException(
  //         errorMessageModel: ErrorMessageModel.fromJson(
  //           Map<String, dynamic>.from(decodedError),
  //         ),
  //       );
  //     }

  //     rethrow;
  //   } catch (e, stackTrace) {
  //     print('❌ Exception in updateFeed: $e');
  //     print(stackTrace);
  //     rethrow;
  //   }
  // }
}
