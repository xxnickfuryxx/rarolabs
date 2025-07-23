import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rarolabs/src/domain/entities/post.dart';
import 'package:rarolabs/src/view/widgets/post_card.dart';

void main() {
  testWidgets('PostCard displays post data correctly',
      (WidgetTester tester) async {
    // Arrange
    final post = Post(
      id: '1',
      authorName: 'Test Author',
      authorAvatar: 'https://example.com/avatar.jpg',
      text: 'Test post text',
      imageUrl: 'https://example.com/image.jpg',
      createdAt: DateTime.now(),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCard(post: post),
        ),
      ),
    );

    // Assert
    expect(find.text(post.authorName), findsOneWidget);
    expect(find.text(post.text), findsOneWidget);
    // You can add more assertions to verify the presence of other widgets and data
  });
}
