import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/error_page.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/features/user_profile/controller/user_profille_controller.dart';
import 'package:the_iconic/features/user_profile/widget/user_profile.dart';
import 'package:the_iconic/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfileView(
          userModel: userModel,
        ),
      );
  final UserModel userModel;
  const UserProfileView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    UserModel updatedUser = userModel;

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.userCollection}.documents.${updatedUser.uid}.update',
              )) {
                updatedUser = UserModel.fromMap(data.payload);
              }
              return UserProfile(user: updatedUser);
            },
            error: (error, st) => ErrorText(
              error: error.toString(),
            ),
            loading: () {
              return UserProfile(user: copyOfUser);
              // return const Center(
              //   child: Text('Loa'),
              // );
            },
          ),
    );
  }
}
