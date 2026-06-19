import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/services/storage_service.dart';
import 'auth_model.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<AuthModel>(
      '${ApiConstants.auth}/login',
      body: {
        'email': email.trim(),
        'password': password,
      },
      decoder: AuthModel.fromJson,
    );

    final data = response.data;

    if (data == null) {
      throw Exception('لم يتم استلام بيانات تسجيل الدخول');
    }

    return data;
  }

  Future<void> logout() async {
    await StorageService.clearSession();
  }
}