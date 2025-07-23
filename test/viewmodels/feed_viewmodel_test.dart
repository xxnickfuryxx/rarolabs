import 'package:flutter_test/flutter_test.dart';
import 'package:rarolabs/src/view/pages/feed/feed_viewmodel.dart';

class MockFeedViewModel extends FeedViewModel {
  @override
  void notifyListeners() {
    // Do nothing.
  }
}

void main() {
  group('FeedViewModel', () {
    late FeedViewModel viewModel;

    setUp(() {
      viewModel = FeedViewModel();
    });

    test('initial posts list should be empty', () {
      expect(viewModel.posts, isEmpty);
    });

    test('generatePosts should generate 15 posts', () {
      viewModel.generatePosts();
      expect(viewModel.posts.length, 15);
    });

    test('generatePosts should generate posts with valid data', () {
      viewModel.generatePosts();
      for (var post in viewModel.posts) {
        expect(post.id, isNotNull);
        expect(post.authorName, isNotNull);
        expect(post.authorAvatar, isNotNull);
        expect(post.text, isNotNull);
        expect(post.imageUrl, isNotNull);
        expect(post.createdAt, isNotNull);
      }
    });

    test('generatePosts should call notifyListeners', () {
      final viewModel = MockFeedViewModel();
      viewModel.generatePosts();
    });
  });
}
