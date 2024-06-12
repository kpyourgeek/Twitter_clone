import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/core/utilis.dart';
import 'package:the_iconic/features/user_profile/controller/user_profille_controller.dart';
import 'package:the_iconic/theme/pallete.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.name ?? '');
    bioController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.bio ?? '');

    // userNameController.dispose();
    // bioController.dispose();
    // nameController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profileFile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfilleControllerProvider);
    return isLoading || user == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(userProfilleControllerProvider.notifier)
                        .updateUserProfile(
                          userModel: user.copyWith(
                              name: nameController.text,
                              bio: bioController.text),
                          context: context,
                          bannerImage: bannerFile,
                          profileImage: profileFile,
                        );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerFile != null
                                ? Image.file(
                                    bannerFile!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : user.bannerPic.isEmpty
                                    ? Container(
                                        color: Pallete.greenColor,
                                      )
                                    : Image.network(
                                        user.bannerPic,
                                        fit: BoxFit.fitWidth,
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 17,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileFile != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(profileFile!),
                                    radius: 40,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.profilePic),
                                    radius: 40,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'name',
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      hintText: 'Bio',
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLines: 4,
                  )
                ],
              ),
            ),
          );
  }
}
