class PostModel {
  final int id;

  final String? caption;

  final String mediaUrl;
  final String mediaType;

  final int likeCount;
  final int commentCount;
  final int bookmarkCount;

  final DateTime createdAt;

  final int fanId;
  final String fanDisplayName;
  final String? fanProfilePicUrl;

  const PostModel({
    required this.id,
    required this.caption,
    required this.mediaUrl,
    required this.mediaType,
    required this.likeCount,
    required this.commentCount,
    required this.bookmarkCount,
    required this.createdAt,
    required this.fanId,
    required this.fanDisplayName,
    required this.fanProfilePicUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      caption: json['caption'],
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      bookmarkCount: json['bookmarkCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      fanId: json['fanId'] ?? 0,
      fanDisplayName: json['fanDisplayName'] ?? '',
      fanProfilePicUrl: json['fanProfilePicUrl'],
    );
  }
}