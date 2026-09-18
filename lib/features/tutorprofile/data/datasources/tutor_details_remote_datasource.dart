import 'package:cristalteacher/core/errors/error_messege_model.dart';
import 'package:cristalteacher/core/errors/exceptions.dart';
import 'package:cristalteacher/core/network/api_endpoints.dart';
import 'package:cristalteacher/core/network/api_helper.dart';
import 'package:cristalteacher/features/tutorprofile/data/models/tutor_details_model.dart';
import 'package:cristalteacher/services/shared_preference_helper.dart';
import 'package:dio/dio.dart';

abstract class TutorDetailsRemoteDataSource {
  Future<TutorDetailsModel> fetchTutorDetails();
}

class TutorDetailsRemoteDataSourceImpl implements TutorDetailsRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<TutorDetailsModel> fetchTutorDetails() async {
    try {
      final pref = SharedPreferenceHelper();

      final baseUrl = await pref.getBaseUrl();
      final token = await pref.getToken();

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('Base URL not set');
      }

      if (token == null || token.isEmpty) {
        throw Exception('Token missing! Please login again.');
      }

      final url = ApiConstants.getTutorDetailsPath(baseUrl);

      final options = await ApiHelper.getAuthOptions(withToken: true);

      final response = await dio.get(url, options: options);

      print('Tutor details response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TutorDetailsModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          response.data as Map<String, dynamic>,
        ),
      );
    } on DioException catch (error) {
      if (error.response?.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            error.response!.data as Map<String, dynamic>,
          ),
        );
      }

      rethrow;
    }
  }
}
