import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import 'post_model.dart';

class PostsService {
  PostsService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PostModel>> getPosts() async {
    final response = await _apiClient.get<List<PostModel>>(
      '${ApiConstants.posts}/feed',
      decoder: (json) => (json as List)
          .map((e) => PostModel.fromJson(e))
          .toList(),
    );

    return response.data ?? [];
  }
}