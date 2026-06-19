class ReportModel {
  const ReportModel({
    required this.id,
    required this.reporterId,
    required this.reporterUsername,
    this.adminId,
    this.adminUsername,
    required this.targetType,
    required this.targetTypeName,
    required this.targetId,
    required this.reason,
    required this.reasonName,
    required this.status,
    required this.statusName,
    required this.createdAt,
  });

  final int id;
  final int reporterId;
  final String reporterUsername;

  final int? adminId;
  final String? adminUsername;

  final int targetType;
  final String targetTypeName;
  final int targetId;

  final int reason;
  final String reasonName;

  final int status;
  final String statusName;

  final String createdAt;

  factory ReportModel.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);

    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse('$value') ?? 0;
    }

    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse('$value');
    }

    String? parseNullableString(dynamic value) {
      if (value == null) return null;
      final text = value.toString().trim();
      return text.isEmpty ? null : text;
    }

    return ReportModel(
      id: parseInt(map['id'] ?? map['Id']),
      reporterId: parseInt(map['reporterId'] ?? map['ReporterId']),
      reporterUsername:
          (map['reporterUsername'] ?? map['ReporterUsername'] ?? '').toString(),
      adminId: parseNullableInt(map['adminId'] ?? map['AdminId']),
      adminUsername: parseNullableString(
        map['adminUsername'] ?? map['AdminUsername'],
      ),
      targetType: parseInt(map['targetType'] ?? map['TargetType']),
      targetTypeName:
          (map['targetTypeName'] ?? map['TargetTypeName'] ?? '').toString(),
      targetId: parseInt(map['targetId'] ?? map['TargetId']),
      reason: parseInt(map['reason'] ?? map['Reason']),
      reasonName: (map['reasonName'] ?? map['ReasonName'] ?? '').toString(),
      status: parseInt(map['status'] ?? map['Status']),
      statusName: (map['statusName'] ?? map['StatusName'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? map['CreatedAt'] ?? '').toString(),
    );
  }

  String get targetTypeArabic {
    switch (targetType) {
      case 0:
        return 'مستخدم';
      case 1:
        return 'منشور';
      case 2:
        return 'تعليق';
      case 3:
        return 'رسالة';
      default:
        return targetTypeName;
    }
  }

  String get reasonArabic {
    switch (reason) {
      case 0:
        return 'إساءة';
      case 1:
        return 'معلومات مضللة';
      case 2:
        return 'إزعاج';
      default:
        return reasonName;
    }
  }

  String get statusArabic {
    switch (status) {
      case 0:
        return 'قيد الانتظار';
      case 1:
        return 'تمت المراجعة';
      case 2:
        return 'مرفوض';
      default:
        return statusName;
    }
  }
}