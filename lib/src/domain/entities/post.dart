// coverage:ignore-file
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String text;
  final String imageUrl;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.text,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}