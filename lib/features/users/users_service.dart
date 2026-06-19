import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';
import 'user_model.dart';

class UsersService {
  UsersService(this._api);

  final ApiClient _api;

  Future<ApiResponse<List<UserModel>>> getUsers({
    String? search,
  }) {
    return _api.get<List<UserModel>>(
      '${ApiConstants.fans}/admin',
      query: {
        if (search != null && search.trim().isNotEmpty)
          'search': search.trim(),
      },
      decoder: (json) {
        final list = json is List ? json : [];
        return list.map(UserModel.fromJson).toList();
      },
    );
  }
}