import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/models/paginated_result.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';
import 'match_model.dart';

class MatchesService {
  MatchesService(this._api);

  final ApiClient _api;

  Future<ApiResponse<PaginatedResult<MatchModel>>> getMatches({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) {
    return _api.get<PaginatedResult<MatchModel>>(
      ApiConstants.matches,
      query: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
      decoder: (json) => PaginatedResult<MatchModel>.fromJson(
        Map<String, dynamic>.from(json as Map),
        MatchModel.fromJson,
      ),
    );
  }

  Future<ApiResponse<MatchModel>> getMatchById(int id) {
    return _api.get<MatchModel>(
      '${ApiConstants.matches}/$id',
      decoder: MatchModel.fromJson,
    );
  }

  Future<void> createMatch({
    required String homeTeam,
    required Uint8List homeTeamLogoBytes,
    required String homeTeamLogoName,
    required String awayTeam,
    required Uint8List awayTeamLogoBytes,
    required String awayTeamLogoName,
    required String league,
    required String matchDate,
    required int hour,
    required int minute,
    required String period,
  }) async {
    await _api.multipart<dynamic>(
      ApiConstants.matches,
      fields: {
        'HomeTeam': homeTeam,
        'AwayTeam': awayTeam,
        'League': league,
        'MatchDate': matchDate,
        'Hour': hour.toString(),
        'Minute': minute.toString(),
        'Period': period,
      },
      files: [
        http.MultipartFile.fromBytes(
          'HomeTeamLogo',
          homeTeamLogoBytes,
          filename: homeTeamLogoName,
        ),
        http.MultipartFile.fromBytes(
          'AwayTeamLogo',
          awayTeamLogoBytes,
          filename: awayTeamLogoName,
        ),
      ],
    );
  }

  Future<void> updateMatch({
    required int id,
    required String homeTeam,
    required String awayTeam,
    required String league,
    required String matchDate,
    required int hour,
    required int minute,
    required String period,
    Uint8List? homeTeamLogoBytes,
    String? homeTeamLogoName,
    Uint8List? awayTeamLogoBytes,
    String? awayTeamLogoName,
  }) async {
    await _api.multipart<dynamic>(
      '${ApiConstants.matches}/$id/update',
      method: 'PATCH',
      fields: {
        'HomeTeam': homeTeam,
        'AwayTeam': awayTeam,
        'League': league,
        'MatchDate': matchDate,
        'Hour': hour.toString(),
        'Minute': minute.toString(),
        'Period': period,
      },
      files: [
        if (homeTeamLogoBytes != null && homeTeamLogoName != null)
          http.MultipartFile.fromBytes(
            'HomeTeamLogo',
            homeTeamLogoBytes,
            filename: homeTeamLogoName,
          ),
        if (awayTeamLogoBytes != null && awayTeamLogoName != null)
          http.MultipartFile.fromBytes(
            'AwayTeamLogo',
            awayTeamLogoBytes,
            filename: awayTeamLogoName,
          ),
      ],
    );
  }

  Future<void> deleteMatch(int id) async {
    await _api.delete<dynamic>('${ApiConstants.matches}/$id');
  }

  Future<void> changeStatus({required int id, required int status}) async {
    await _api.patch<dynamic>(
      '${ApiConstants.matches}/$id/status',
      body: status,
    );
  }

  Future<void> openPredictions(int id) async {
    await _api.patch<dynamic>('${ApiConstants.matches}/$id/predictions-open');
  }

  Future<void> closePredictions(int id) async {
    await _api.patch<dynamic>('${ApiConstants.matches}/$id/predictions-close');
  }
}
