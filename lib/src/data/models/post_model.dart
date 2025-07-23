// coverage:ignore-file
import 'package:rarolabs/src/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorName,
    required super.authorAvatar,
    required super.text,
    required super.imageUrl,
    required super.createdAt,
  });
}
