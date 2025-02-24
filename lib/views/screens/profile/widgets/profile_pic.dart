import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controllers/profile_bloc/profile_bloc.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_images.dart';
import 'custom_list_tile.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileBloc profileBloc = ProfileBloc.get(context);

    //----- Show image picker options -----//
    Future<void> showImagePickerOptions(BuildContext context) async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                // Pick from camera option
                CustomListTile(
                  title: 'take_photo'.tr(),
                  icon: Icons.photo_camera,
                  onTap: () {
                    try {
                      Navigator.pop(context);
                      profileBloc.add(UpdateAvatarEvent(true));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Cannot change profile photo')));
                    }
                  },
                ),
                // Pick from gallery option
                CustomListTile(
                  title: 'choose_from_gallery'.tr(),
                  icon: Icons.photo_library,
                  onTap: () {
                    try {
                      Navigator.pop(context);
                      profileBloc.add(UpdateAvatarEvent(false));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot change profile photo'),
                        ),
                      );
                    }
                  },
                ),
                // Remove profile photo option
                CustomListTile(
                  title: 'remove-photo'.tr(),
                  icon: Icons.delete_forever,
                  onTap: () {
                    try {
                      Navigator.pop(context);
                      profileBloc.add(RemoveProfileImageEvent());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot change profile photo'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        ProfileBloc profileBloc = context.read<ProfileBloc>();

        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            //-- profile photo --//
            CircleAvatar(
              radius: 70,
              // To check if the saved image existed or to show the default one
              backgroundImage: profileBloc.imagePath == AppImages.user
                  ? AssetImage(profileBloc.imagePath)
                  : FileImage(
                      File(profileBloc.imagePath),
                    ),
            ),
            //-- Change profile icon --//
            Positioned(
              right: 5.0,
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: AppColors.greyColor.withValues(alpha: 0.8),
                child: IconButton(
                  onPressed: () => showImagePickerOptions(context),
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.white,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
