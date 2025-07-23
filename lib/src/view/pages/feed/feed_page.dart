import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/l10n/app_localizations.dart';
import 'package:rarolabs/src/view/pages/feed/feed_viewmodel.dart';
import 'package:rarolabs/src/view/widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    Provider.of<FeedViewModel>(context, listen: false).generatePosts();

    // Adiciona um pequeno atraso para iniciar a animação após a construção da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _startAnimation = true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${locale.feedsTitle}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: viewModel.posts.length,
        itemBuilder: (context, index) {
          final post = viewModel.posts[index];
          // Calcula um atraso para cada item da lista, criando um efeito cascata
          final delay = Duration(milliseconds: 100 * (index % 10));

          return AnimatedOpacity(
            opacity: _startAnimation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500) + delay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500) + delay,
              curve: Curves.easeOut,
              transform:
                  Matrix4.translationValues(0, _startAnimation ? 0 : 50, 0),
              child: PostCard(post: post),
            ),
          );
        },
      ),
    );
  }
}
