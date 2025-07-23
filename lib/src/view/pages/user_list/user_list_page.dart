import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/l10n/app_localizations.dart';
import 'package:rarolabs/src/view/pages/user_list/user_list_viewmodel.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_page.dart';
import 'package:rarolabs/src/view/widgets/user_tile.dart';
import 'package:rarolabs/src/view/widgets/error_message.dart';
import 'package:rarolabs/src/view/pages/login/login_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UserListViewModel>(context, listen: false);
    viewModel.fetchUsers();

    // Dispara a animação após a tela ser construída
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _startAnimation = true);
        }
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        viewModel.fetchNextPage();
      }
    });

    _searchController.addListener(() {
      viewModel.search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    final viewModel = Provider.of<UserListViewModel>(context, listen: false);
    viewModel.logout().then((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserListViewModel>();
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${locale.users}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: '${locale.logout}',
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => {},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '${locale.userListSearchByName}',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
            Expanded(
              child: _buildUserList(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(UserListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.users.isEmpty) {
      return ErrorMessage(
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.fetchUsers(),
      );
    }

    if (viewModel.filteredUsers.isEmpty && _searchController.text.isNotEmpty) {
      final locale = AppLocalizations.of(context);
      return Center(child: Text('${locale.userListNotFound}'));
    }

    if (viewModel.users.isEmpty) {
      final locale = AppLocalizations.of(context);
      return Center(child: Text('${locale.userListNoShow}'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: viewModel.filteredUsers.length +
          (viewModel.isLoadingNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.filteredUsers.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final user = viewModel.filteredUsers[index];
        //Calculate a delay for a item, make a cascade effect.
        final delay = Duration(milliseconds: 100 * (index % 15));

        return AnimatedOpacity(
          opacity: _startAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400) + delay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400) + delay,
            curve: Curves.easeOut,
            transform:
                Matrix4.translationValues(0, _startAnimation ? 0 : 30, 0),
            child: Container(
              child: UserTile(
                user: user,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => UserProfilePage(user: user),
                  ));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
