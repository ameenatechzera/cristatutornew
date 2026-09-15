import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/errors/error_messege_model.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/models/master_response_model.dart';
import 'package:cristalteacher/core/network/api_endpoints.dart';
import 'package:cristalteacher/core/network/api_helper.dart';
import 'package:cristalteacher/features/exam/data/models/examterm_response_model.dart';
import 'package:cristalteacher/features/exam/data/models/fetch_examlist_model.dart';
import 'package:cristalteacher/features/exam/data/models/fetch_examtype_response_model.dart';
import 'package:cristalteacher/features/exam/data/models/saveexam_response_model.dart';
import 'package:cristalteacher/features/exam/domain/parameters/save_exam_parameter.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:dio/dio.dart';

abstract class ExamManagementRemoteDataSource {
  Future<ExamListingResponseModel> fetchExamListing();

  Future<ExamTypeResponseModel> getExamTypes();
  Future<ExamTermResponseModel> getExamTerms();
  Future<SaveExamResponseModel> saveExam(SaveExamParameter parameter);
  Future<MasterResponseModel> deleteExam(int examId);
  Future<ExamListingResponseModel> updateExam(
    int examId,
    SaveExamParameter parameter,
  );
}

class ExamManagementRemoteDataSourceImpl
    implements ExamManagementRemoteDataSource {
  final Dio dio;

  ExamManagementRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<ExamListingResponseModel> fetchExamListing() async {
    try {
      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.getExamListingPath(baseUrl);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      final Response<dynamic> response = await dio.get(url, options: options);

      if (response.data is! Map) {
        throw Exception('Invalid exam listing response');
      }

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExamListingResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error) {
      final dynamic data = error.response?.data;

      if (data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(data),
          ),
        );
      }

      throw Exception(error.message ?? 'Unable to fetch exam listing');
    }
  }

  @override
  Future<ExamTypeResponseModel> getExamTypes() async {
    try {
      final int branchId = AppData.branchId ?? 1;

      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.getExamTypesPath(baseUrl, branchId);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      final Response<dynamic> response = await dio.get(url, options: options);

      if (response.data is! Map) {
        throw Exception('Invalid exam types response');
      }

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExamTypeResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error) {
      final dynamic data = error.response?.data;

      if (data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(data),
          ),
        );
      }

      throw Exception(error.message ?? 'Unable to fetch exam types');
    }
  }

  @override
  Future<ExamTermResponseModel> getExamTerms() async {
    try {
      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.getExamTermsPath(baseUrl);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      final Response<dynamic> response = await dio.get(url, options: options);

      if (response.data is! Map) {
        throw Exception('Invalid exam terms response');
      }

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExamTermResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error) {
      final dynamic data = error.response?.data;

      if (data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(data),
          ),
        );
      }

      throw Exception(error.message ?? 'Unable to fetch exam terms');
    }
  }

  @override
  Future<SaveExamResponseModel> saveExam(SaveExamParameter parameter) async {
    try {
      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.saveExamPath(baseUrl);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      final Response<dynamic> response = await dio.post(
        url,
        data: parameter.toJson(),
        options: options,
      );

      if (response.data is! Map) {
        throw Exception('Invalid save exam response');
      }

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SaveExamResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error) {
      final dynamic data = error.response?.data;

      if (data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(data),
          ),
        );
      }

      throw Exception(error.message ?? 'Unable to save exam');
    }
  }

  @override
  Future<MasterResponseModel> deleteExam(int examId) async {
    try {
      if (examId <= 0) {
        throw Exception('Invalid Exam ID');
      }

      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.deleteExamPath(baseUrl, examId);
      print(url);
      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      final Response<dynamic> response = await dio.get(url, options: options);

      if (response.data is! Map) {
        throw Exception('Invalid delete exam response');
      }

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MasterResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error) {
      final dynamic data = error.response?.data;

      if (data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(data),
          ),
        );
      }

      throw Exception(error.message ?? 'Unable to delete exam');
    }
  }

  @override
  Future<ExamListingResponseModel> updateExam(
    int examId,
    SaveExamParameter parameter,
  ) async {
    try {
      if (examId <= 0) {
        throw ArgumentError('Invalid Exam ID');
      }

      final SharedPreferenceHelper preference = SharedPreferenceHelper();

      final String? baseUrl = await preference.getBaseUrl();

      if (baseUrl == null || baseUrl.trim().isEmpty) {
        throw Exception('Base URL not set');
      }

      final String url = ApiConstants.updateExamPath(baseUrl, examId);

      final Options options = await ApiHelper.getAuthOptions(withToken: true);

      final Response<dynamic> response = await dio.post<dynamic>(
        url,
        data: parameter.toJson(),
        options: options,
      );

      if (response.data is! Map) {
        throw Exception('Invalid update exam response');
      }

      final Map<String, dynamic> responseData = Map<String, dynamic>.from(
        response.data as Map,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExamListingResponseModel.fromJson(responseData);
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    } on DioException catch (error) {
      final dynamic data = error.response?.data;

      if (data is Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            Map<String, dynamic>.from(data),
          ),
        );
      }

      throw Exception(error.message ?? 'Unable to update exam');
    }
  }
}
