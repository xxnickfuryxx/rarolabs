import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rarolabs/src/domain/entities/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        alignment: Alignment.centerLeft,
        child: ListTile(
          leading: Hero(
            tag: 'avatar_${user.id}',
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.avatar),
              child: CachedNetworkImage(
                imageUrl: user.avatar,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Text(user.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}

// view/widgets/post_card.dart
