class MatchModel {
  const MatchModel({
    required this.id,
    required this.homeTeam,
    this.homeTeamLogoUrl,
    required this.awayTeam,
    this.awayTeamLogoUrl,
    required this.league,
    required this.matchDate,
    required this.hour,
    required this.minute,
    required this.period,
    required this.status,
    required this.predictionState,
  });

  final int id;
  final String homeTeam;
  final String? homeTeamLogoUrl;
  final String awayTeam;
  final String? awayTeamLogoUrl;
  final String league;
  final String matchDate;
  final int hour;
  final int minute;
  final String period;
  final String status;
  final String predictionState;

  factory MatchModel.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);

    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse('$value') ?? 0;
    }

    String? parseNullableString(dynamic value) {
      if (value == null) return null;
      final text = value.toString().trim();
      return text.isEmpty ? null : text;
    }

    return MatchModel(
      id: parseInt(map['id'] ?? map['Id']),
      homeTeam: (map['homeTeam'] ?? map['HomeTeam'] ?? '').toString(),
      homeTeamLogoUrl: parseNullableString(
        map['homeTeamLogoUrl'] ?? map['HomeTeamLogoUrl'],
      ),
      awayTeam: (map['awayTeam'] ?? map['AwayTeam'] ?? '').toString(),
      awayTeamLogoUrl: parseNullableString(
        map['awayTeamLogoUrl'] ?? map['AwayTeamLogoUrl'],
      ),
      league: (map['league'] ?? map['League'] ?? '').toString(),
      matchDate: (map['matchDate'] ?? map['MatchDate'] ?? '').toString(),
      hour: parseInt(map['hour'] ?? map['Hour']),
      minute: parseInt(map['minute'] ?? map['Minute']),
      period: (map['period'] ?? map['Period'] ?? '').toString(),
      status: parseStatus(map['status'] ?? map['Status']),
      predictionState: parsePredictionState(
        map['predictionState'] ?? map['PredictionState'],
      ),
    );
  }

  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  static String parseStatus(dynamic value) {
    switch ('$value') {
      case '0':
        return 'قادمة';
      case '1':
        return 'مباشرة';
      case '2':
        return 'منتهية';
      default:
        return value?.toString() ?? 'غير معروف';
    }
  }

  static String parsePredictionState(dynamic value) {
    switch ('$value') {
      case '0':
        return 'مغلقة';
      case '1':
        return 'مفتوحة';
      default:
        return value?.toString() ?? 'غير معروف';
    }
  }
}
