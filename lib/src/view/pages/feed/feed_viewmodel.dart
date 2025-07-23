import 'package:flutter/foundation.dart';
import 'package:faker/faker.dart';
import 'package:rarolabs/src/domain/entities/post.dart';
import 'package:rarolabs/src/data/models/post_model.dart';

class FeedViewModel extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  void generatePosts() {
    final faker = Faker();
    _posts = List.generate(15, (index) {
      return PostModel(
        id: faker.guid.guid(),
        authorName: faker.person.name(),
        authorAvatar: faker.image
            .image(keywords: ['avatar', 'person', 'user'], random: true),
        text: faker.lorem.sentences(3).join(' '),
        imageUrl: faker.image.image(random: true, width: 600, height: 400),
        createdAt: faker.date.dateTime(minYear: 2020, maxYear: 2025),
      );
    });
    notifyListeners();
  }
}
