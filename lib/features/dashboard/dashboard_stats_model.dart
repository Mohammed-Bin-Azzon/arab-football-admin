class DashboardStatsModel {
  const DashboardStatsModel({
    required this.usersCount,
    required this.matchesCount,
    required this.postsCount,
    required this.reportsCount,
    required this.pendingReportsCount,
  });

  final int usersCount;
  final int matchesCount;
  final int postsCount;
  final int reportsCount;
  final int pendingReportsCount;

  factory DashboardStatsModel.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);

    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse('$value') ?? 0;
    }

    return DashboardStatsModel(
      usersCount: parseInt(map['usersCount'] ?? map['UsersCount']),
      matchesCount: parseInt(map['matchesCount'] ?? map['MatchesCount']),
      postsCount: parseInt(map['postsCount'] ?? map['PostsCount']),
      reportsCount: parseInt(map['reportsCount'] ?? map['ReportsCount']),
      pendingReportsCount: parseInt(
        map['pendingReportsCount'] ?? map['PendingReportsCount'],
      ),
    );
  }
}