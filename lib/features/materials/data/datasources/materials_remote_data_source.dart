import 'dart:convert';
import 'dart:io';

import 'package:cristalteacher/core/errors/error_messege_model.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/network/api_endpoints.dart';
import 'package:cristalteacher/core/network/api_helper.dart';
import 'package:cristalteacher/features/materials/data/models/fetch_material_model.dart';
import 'package:cristalteacher/features/materials/data/models/material_details_model.dart';
import 'package:cristalteacher/features/materials/domain/parameter/fetch_material_parameter.dart';
import 'package:cristalteacher/features/materials/domain/parameter/save_material_parameter.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class MaterialRemoteDataSource {
  Future<FetchMaterialModel> fetchMaterials(FetchMaterialParameter params);
  Future<MasterResponseModel> saveMaterial(SaveMaterialParameter params);
  Future<MasterResponseModel> deleteMaterial(int materialId);
  Future<MaterialDetailsResponseModel> fetchMaterialDetails(int materialId);
}

class MaterialRemoteDataSourceImpl implements MaterialRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<FetchMaterialModel> fetchMaterials(
    FetchMaterialParameter params,
  ) async {
    print('📘 Fetch Materials Called');
    print('FetchMaterialParameter: ${params.toJson()}');

    try {
      final baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Base URL not set");
      }

      final url = ApiConstants.getFetchMaterialPath(baseUrl);

      print("📘 URL : $url");

      final options = await ApiHelper.getAuthOptions(withToken: true);

      final response = await dio.post(
        url,
        data: params.toJson(),
        options: options,
      );

      print('📘 Status Code: ${response.statusCode}');
      print('📘 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FetchMaterialModel.fromJson(response.data);
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Exception in fetchMaterials: $e');
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> saveMaterial(SaveMaterialParameter params) async {
    debugPrint('');
    debugPrint('==============================================');
    debugPrint('📘 SAVE MATERIAL API START');
    debugPrint('==============================================');

    try {
      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();
      final String? token = await preference.getToken();
      final String? databaseName = await preference.getDatabaseName();

      debugPrint('📌 PREFERENCE VALUES');
      debugPrint('----------------------------------------------');
      debugPrint('Base URL      : $baseUrl');
      debugPrint('Token exists  : ${token != null && token.isNotEmpty}');
      debugPrint(
        'Database set : ${databaseName != null && databaseName.isNotEmpty}',
      );
      debugPrint('----------------------------------------------');

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      if (token == null || token.trim().isEmpty) {
        throw Exception('Token missing! Please login again.');
      }

      final String url = ApiConstants.saveMaterialPath(baseUrl);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      // Dio automatically provides the multipart content type and boundary.
      options.contentType = null;
      options.headers?.remove('Content-Type');
      options.headers?.remove('content-type');

      debugPrint('📌 REQUEST DETAILS');
      debugPrint('----------------------------------------------');
      debugPrint('URL          : $url');
      debugPrint('Method       : POST');
      debugPrint('Content-Type : Multipart FormData');
      debugPrint('----------------------------------------------');

      final FormData formData = FormData();
      final List<Map<String, dynamic>> standardDivisionPairs = params
          .standardDivisionList
          .map(
            (pair) => {
              'StandardId': pair.standardId,
              'DivisionId': pair.divisionId,
            },
          )
          .toList();

      final String standardDivisionJson = jsonEncode(standardDivisionPairs);

      debugPrint('StandardId/DivisionId JSON: $standardDivisionJson');
      formData.fields.addAll([
        MapEntry('StaffId', params.staffId.toString()),
        MapEntry('AccYear', params.accYear),
        // MapEntry('StandardId', params.standardId.toString()),
        // MapEntry('DivisionId', params.divisionId.toString()),
        MapEntry('StandardId', standardDivisionJson),
        MapEntry('SubjectId', params.subjectId.toString()),
        MapEntry('branchId', params.branchId.toString()),
        MapEntry('CreatedUser', params.createdUser),
        MapEntry('documentName', params.documentName),
        MapEntry('notes', params.notes),
        MapEntry('link', params.link),
        MapEntry('favorite', params.favorite ? 'true' : 'false'),
      ]);

      debugPrint('📌 ADDING MATERIAL FILES');
      debugPrint('----------------------------------------------');
      debugPrint('Selected material count: ${params.materials.length}');

      // Material files are optional.
      // Documents contain a file, while Links and Notes may have no files.
      if (params.materials.isEmpty) {
        debugPrint(
          'ℹ️ No material file selected. '
          'Submitting Notes/Link using text fields only.',
        );
      }

      for (int index = 0; index < params.materials.length; index++) {
        final File file = params.materials[index];

        debugPrint('');
        debugPrint('Material file ${index + 1}');
        debugPrint('Path: ${file.path}');

        final bool exists = await file.exists();

        debugPrint('Exists: $exists');

        if (!exists) {
          throw Exception('Selected file does not exist: ${file.path}');
        }

        final int fileSize = await file.length();
        final double fileSizeMb = fileSize / (1024 * 1024);

        final String fileName = file.path.split(Platform.pathSeparator).last;

        debugPrint('Filename: $fileName');
        debugPrint('Size bytes: $fileSize');
        debugPrint('Size MB: ${fileSizeMb.toStringAsFixed(2)}');

        final MultipartFile multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );

        debugPrint('Multipart filename: ${multipartFile.filename}');
        debugPrint('Multipart length: ${multipartFile.length}');
        debugPrint('Multipart content type: ${multipartFile.contentType}');

        formData.files.add(MapEntry('Material[]', multipartFile));

        debugPrint('✅ Added with field key: Material[]');
      }

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('📋 FINAL FORMDATA TEXT FIELDS');
      debugPrint('==============================================');

      if (formData.fields.isEmpty) {
        debugPrint('⚠️ No text fields found');
      }

      for (final MapEntry<String, String> field in formData.fields) {
        debugPrint('${field.key}: ${field.value}');
      }

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('📁 FINAL FORMDATA FILES');
      debugPrint('==============================================');

      if (formData.files.isEmpty) {
        debugPrint('ℹ️ No files added. Sending text-only material request.');
      }

      for (int index = 0; index < formData.files.length; index++) {
        final MapEntry<String, MultipartFile> entry = formData.files[index];

        debugPrint('File ${index + 1}');
        debugPrint('Field key    : ${entry.key}');
        debugPrint('Filename     : ${entry.value.filename}');
        debugPrint('Length       : ${entry.value.length}');
        debugPrint('Content type : ${entry.value.contentType}');
        debugPrint('----------------------------------------------');
      }

      debugPrint('Total fields : ${formData.fields.length}');
      debugPrint('Total files  : ${formData.files.length}');

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('📤 CALLING SAVE MATERIAL API');
      debugPrint('==============================================');

      final Response<dynamic> response = await dio.post<dynamic>(
        url,
        data: formData,
        options: options,
        onSendProgress: (int sent, int total) {
          if (total > 0) {
            final double percentage = sent / total * 100;

            debugPrint(
              '📤 Upload: '
              '${percentage.toStringAsFixed(1)}% '
              '($sent/$total bytes)',
            );
          }
        },
      );

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('✅ SAVE MATERIAL RESPONSE');
      debugPrint('==============================================');
      debugPrint('Status code : ${response.statusCode}');
      debugPrint('Response    : ${response.data}');
      debugPrint('==============================================');

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid Save Material API response: ${response.data}');
      }

      return MasterResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      final int? statusCode = error.response?.statusCode;
      final dynamic responseData = error.response?.data;

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('❌ SAVE MATERIAL DIO EXCEPTION');
      debugPrint('==============================================');
      debugPrint('URL          : ${error.requestOptions.uri}');
      debugPrint('Method       : ${error.requestOptions.method}');
      debugPrint('Content-Type : ${error.requestOptions.contentType}');
      debugPrint('Data type    : ${error.requestOptions.data.runtimeType}');
      debugPrint('Status code  : $statusCode');
      debugPrint('Response     : $responseData');
      debugPrint('Error message: ${error.message}');
      debugPrint('==============================================');

      final dynamic failedRequestData = error.requestOptions.data;

      if (failedRequestData is FormData) {
        debugPrint('');
        debugPrint('==============================================');
        debugPrint('📋 FAILED REQUEST TEXT FIELDS');
        debugPrint('==============================================');

        for (final MapEntry<String, String> field in failedRequestData.fields) {
          debugPrint('${field.key}: ${field.value}');
        }

        debugPrint('');
        debugPrint('==============================================');
        debugPrint('📁 FAILED REQUEST FILES');
        debugPrint('==============================================');

        if (failedRequestData.files.isEmpty) {
          debugPrint('ℹ️ Failed request contained no files.');
        }

        for (final MapEntry<String, MultipartFile> file
            in failedRequestData.files) {
          debugPrint('Field key    : ${file.key}');
          debugPrint('Filename     : ${file.value.filename}');
          debugPrint('Length       : ${file.value.length}');
          debugPrint('Content type : ${file.value.contentType}');
          debugPrint('----------------------------------------------');
        }
      }

      debugPrintStack(stackTrace: stackTrace);

      if (statusCode == 413) {
        throw Exception(
          'The server rejected the upload because '
          'the complete request is too large.',
        );
      }

      if (responseData is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseData),
        );
      }

      throw Exception(
        responseData?.toString() ?? error.message ?? 'Unable to save material',
      );
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('❌ EXCEPTION IN SAVE MATERIAL');
      debugPrint('==============================================');
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      debugPrint('==============================================');

      rethrow;
    }
  }

  @override
  Future<MasterResponseModel> deleteMaterial(int materialId) async {
    try {
      final String? baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      if (materialId <= 0) {
        throw Exception('Invalid material ID');
      }

      final String url = ApiConstants.deleteMaterialPath(baseUrl, materialId);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      debugPrint('Delete Material URL: $url');

      final Response<dynamic> response = await dio.get(url, options: options);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        if (response.data is Map<String, dynamic>) {
          return MasterResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          );
        }

        /*
       * A 204 response normally has no response body.
       * If your API always returns MasterResponseModel,
       * you can remove this section.
       */
        throw Exception('Material deleted, but the response body is empty');
      }

      if (response.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            response.data as Map<String, dynamic>,
          ),
        );
      }

      throw Exception('Unable to delete material');
    } on DioException catch (error) {
      final dynamic responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseData),
        );
      }

      throw Exception(
        responseData?.toString() ??
            error.message ??
            'Unable to delete material',
      );
    }
  }

  @override
  Future<MaterialDetailsResponseModel> fetchMaterialDetails(
    int materialId,
  ) async {
    debugPrint('');
    debugPrint('==============================================');
    debugPrint('📘 FETCH MATERIAL DETAILS API START');
    debugPrint('==============================================');

    try {
      final String? baseUrl = await SharedPreferenceHelper().getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      if (materialId <= 0) {
        throw Exception('Invalid material ID');
      }

      final String url = ApiConstants.getMaterialDetailsPath(
        baseUrl,
        materialId,
      );

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      debugPrint('Material ID : $materialId');
      debugPrint('URL         : $url');
      debugPrint('Method      : GET');

      final Response<dynamic> response = await dio.get<dynamic>(
        url,
        options: options,
      );

      debugPrint('Status Code : ${response.statusCode}');
      debugPrint('Response    : ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return MaterialDetailsResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          );
        }

        if (response.data is Map) {
          return MaterialDetailsResponseModel.fromJson(
            Map<String, dynamic>.from(response.data as Map),
          );
        }

        throw Exception(
          'Invalid Material Details API response: ${response.data}',
        );
      }

      if (response.data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(response.data as Map),
          ),
        );
      }

      throw Exception('Unable to fetch material details');
    } on DioException catch (error, stackTrace) {
      final int? statusCode = error.response?.statusCode;
      final dynamic responseData = error.response?.data;

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('❌ FETCH MATERIAL DETAILS DIO EXCEPTION');
      debugPrint('==============================================');
      debugPrint('URL          : ${error.requestOptions.uri}');
      debugPrint('Method       : ${error.requestOptions.method}');
      debugPrint('Status code  : $statusCode');
      debugPrint('Response     : $responseData');
      debugPrint('Error message: ${error.message}');
      debugPrintStack(stackTrace: stackTrace);

      if (responseData is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(responseData),
          ),
        );
      }

      throw Exception(
        responseData?.toString() ??
            error.message ??
            'Unable to fetch material details',
      );
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('❌ EXCEPTION IN FETCH MATERIAL DETAILS');
      debugPrint('==============================================');
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }
}
