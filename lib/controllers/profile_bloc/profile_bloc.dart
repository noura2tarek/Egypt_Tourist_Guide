import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/shared_prefs_service.dart';
import '../../models/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<LoadProfileEvent>(_loadProfileData);
    on<UpdateProfileEvent>(_updateProfileData);
    on<ToggleEditingEvent>(_toggleEditing);
    on<TogglePasswordVisibilityEvent>(_togglePasswordProfileVisibility);
    on<UpdateAvatarEvent>(_updateProfileImage);
    on<RemoveProfileImageEvent>(_removeProfileImage);
  }

  // Static method to return profile bloc object (to apply singleton pattern)
  static ProfileBloc get(context) => BlocProvider.of(context);

  UserModel user = UserModel(
    fullName: 'User Name',
    email: 'user@example.com',
    password: 'Password123@',
    phoneNumber: '01###-###-####',
    address: '123 Main Street',
  );
  bool isEditing = false;

  bool isVisibleProfilePassword = false;

  // handle toggle password visibility event
  Future<void> _togglePasswordProfileVisibility(
      TogglePasswordVisibilityEvent event, Emitter<ProfileState> emit) async {
    isVisibleProfilePassword = !isVisibleProfilePassword;
    emit(PasswordVisibilityToggledState());
  }

  String imagePath = SharedPrefsService.getProfilePhoto();

  // handle load profile data event
  Future<void> _loadProfileData(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      // Get user data from firebase
      user = await FirebaseService.getUserData();
      imagePath = SharedPrefsService.getProfilePhoto();

      emit(ProfileLoadedState());
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  // handle update profile data event
  Future<void> _updateProfileData(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      // Update user data in firebase
      await FirebaseService.updateUserData(
        user: event.user,
      );
      emit(ProfileUpdatedState());
      isEditing = !isEditing;
      emit(ProfileEditingToggledState());
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<void> _toggleEditing(
      ToggleEditingEvent event, Emitter<ProfileState> emit) async {
    isEditing = !isEditing;
    emit(ProfileEditingToggledState());
  }

  //----- Save photo locally -----//
  Future<String?> savePhotoLocally(XFile image) async {
    try {
      // Get the application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Generate a unique file name (e.g., using a timestamp)
      final String fileName =
          'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create the file path
      final String filePath = '${appDir.path}/$fileName';

      // Save the photo to the application folder
      final File savedFile = File(filePath);
      await savedFile.writeAsBytes(await image.readAsBytes());

      // Return the saved file path
      return savedFile.path;
    } catch (e) {
      return null;
    }
  }

  final ImagePicker picker = ImagePicker();

  // handle update profile image event
  _updateProfileImage(
      UpdateAvatarEvent event, Emitter<ProfileState> emit) async {
    final XFile? image;
    if (event.isFromCamera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }
    if (image != null) {
      // Save the photo locally and get the file path
      final String? savedFilePath = await savePhotoLocally(image);
      if (savedFilePath != null) {
        // Save the file path to SharedPreferences
        SharedPrefsService.saveStringData(
          key: SharedPrefsService.userProfilePicture,
          value: savedFilePath,
        );
      }
      imagePath = SharedPrefsService.getProfilePhoto();
      emit(ProfileImageUpdatedState());
    }
  }

  // handle remove profile image event
  _removeProfileImage(
      RemoveProfileImageEvent event, Emitter<ProfileState> emit) async {
    // Delete photo saved in shared pref
    await SharedPrefsService.clearStringData(
      key: SharedPrefsService.userProfilePicture,
    );
    imagePath = SharedPrefsService.getProfilePhoto();
    emit(ProfileImageUpdatedState());
  }
}
