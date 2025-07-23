import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_viewmodel.dart';

class UserProfilePage extends StatefulWidget {
  final User user;
  const UserProfilePage({super.key, required this.user});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    // Generate fake data when the page is initialized
    Provider.of<UserProfileViewModel>(context, listen: false)
        .generateFakeData();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.fullName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'avatar_${widget.user.id}',
              child: CircleAvatar(
                radius: 60,
                backgroundImage: CachedNetworkImageProvider(widget.user.avatar),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.user.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildProfileInfoCard(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(UserProfileViewModel viewModel) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.work, 'Cargo', viewModel.jobTitle,
                key: const Key('profile_jobTitle')),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.business_center, 'Área', viewModel.jobArea,
                key: const Key('profile_jobArea')),
            const SizedBox(height: 24),
            const Text(
              'Biografia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              key: const Key('profile_biography'),
              viewModel.biography,
              textAlign: TextAlign.justify,
              style:
                  TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Key? key}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 16),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            key: key,
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
