import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/file_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l_earn/Presentation/components/display_image.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/mixins.dart';

class EditProfilePage extends StatefulWidget with AppBarMixin, ImageMixin {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _handleController = TextEditingController();
  final _genderController = TextEditingController();
  final _schoolController = TextEditingController();
  final _levelController = TextEditingController();
  final _departmentController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final __newConfirmPasswordController = TextEditingController();
  late final User user;

  final _formKey = GlobalKey<FormState>();

  XFile? _pickedBannerImage;
  XFile? _pickedProfilePicture;

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthCubit>().state.user!;

    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email ?? '';
    _handleController.text = user.handle ?? '';
    _genderController.text = user.gender ?? '';
    _schoolController.text = user.school ?? '';
    _levelController.text =
        user.level.toString() == 'null' ? '' : '${user.level} level';
    _departmentController.text =
        user.department.toString() == 'null' ? '' : user.department.toString();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _handleController.dispose();
    _genderController.dispose();
    _schoolController.dispose();
    _levelController.dispose();
    _departmentController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    __newConfirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileEdited) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Your profile has been edited successfully"),
          ));
        } else if (state is AuthEditingProfileFailed) {
          showDialog(
              context: context,
              builder: (context) {
                return MyDialog(
                  title: state.error!.title,
                  content: state.error!.content,
                );
              });
        }
      },
      child: Scaffold(
          appBar: widget.buildAppBar(context, automaticallyImplyLeading: Platform.isWindows, title: 'Edit profile', actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) {
                return current is AuthEditingProfile ||
                    current is AuthProfileEdited ||
                    current is AuthEditingProfileFailed;
              }, builder: (context, state) {
                //                 AuthEditingProfile
                // AuthProfileEdited
                // AuthEditingProfileFailed
                return MyContainerButton(
                    text: 'Edit',
                    loading: state is AuthEditingProfile,
                    onPressed: () {
                      print('Edit profile pressed');

                      final bool? isValid = _formKey.currentState?.validate();

                      if (isValid == true) {
                        Map<String, String> details = {
                          // PERSONAL INFORMATION
                          "firstName": _firstNameController.text.trim(),
                          "lastName": _lastNameController.text.trim(),
                          "email": _emailController.text.trim(),
                          "gender": _genderController.text.toLowerCase().trim(),

                          // SCHOOL INFORMATION
                          "school": _schoolController.text.trim(),
                          "department": _departmentController.text.trim(),
                          "level": _levelController.text.trim().split(' ')[0],

                          // CHANGE PASSWORD
                          "currentPassword":
                              _currentPasswordController.text.trim(),
                          "newPassword": _newPasswordController.text.trim(),
                          "newConfirmPassword":
                              __newConfirmPasswordController.text.trim()
                        };

                        details["handle"] =
                            "@${_handleController.text.trim().replaceAll('@', '')}";

                        List<File> imageFiles = [];

                        print(
                            "::: U P D A T E   D E T A I L S   I S   $details");

                        if (_pickedBannerImage != null) {
                          imageFiles.add(File(
                              name: 'banner', path: _pickedBannerImage!.path));
                        }

                        if (_pickedProfilePicture != null) {
                          imageFiles.add(File(
                              name: 'profilePicture',
                              path: _pickedProfilePicture!.path));
                        }

                        print(
                            "::: E D I T   D E T A I L S   $details,\n F I L E S   $imageFiles");
                        context.read<AuthCubit>().editProfile(
                            details: details, imageFiles: imageFiles);
                      }
                    });
              }),
            )
          ]),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                //? BANNER
                _pickedBannerImage == null
                    ? GestureDetector(
                        onTap: _getSingleImageFromSource,
                        child: const ImageLoadingPlaceHolderWidget(
                          width: double.maxFinite,
                          height: 150,
                          placeHolderText: 'Click to add image',
                        ),
                      )
                    : GestureDetector(
                        onTap: _getSingleImageFromSource,
                        child: DisplayImage(
                          pickedImage: _pickedBannerImage,
                          borderRadius: 0,
                          minHeight: 150,
                          maxHeight: 150,
                        ),
                      ),

                const SizedBox(
                  height: 10,
                ),

                //? PROFILE PICTURE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ChangeProfilePictureWidget(
                    user: user,
                    pickedImage: _pickedProfilePicture,
                    onChangePressed: () {
                      //TODO: IMPLEMENT IMAGE PICKER
                      print('::: C H A N G E   I M A G E   P R E S S E D :::');
                      _getSingleImageFromSource(type: 'profilePicture');
                    },
                  ),
                ),

                //? 10 unit spacing
                const SizedBox(height: 24),

                // USER INFOMATION
                Text(
                  "Your personal information",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                //? FIRST NAME AND LAST NAME
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: MyTextFormField(
                              hintText: 'First name',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9@]'))
                              ],
                              controller: _firstNameController,
                              validator: firstNameFieldValidator)),

                      //? 10 unit spacing
                      const SizedBox(width: 10),

                      Expanded(
                          child: MyTextFormField(
                              hintText: 'Last name',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9@]'))
                              ],
                              controller: _lastNameController,
                              validator: lastNameFieldValidator)),
                    ],
                  ),
                ),

                //? 10 unit spacing
                const SizedBox(height: 10),

                //? EMAIL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                      readOnly: true,
                      controller: _emailController,
                      hintText: 'Email',
                      validator: emailValidator),
                ),

                //? 10 unit spacing
                const SizedBox(height: 10),

                //? HANDLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                      hintText: 'Handle',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9@]')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      controller: _handleController,
                      validator: handleValidator),
                ),

                //? 10 unit spacing
                const SizedBox(height: 10),

                //? GENDER

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _genderController,
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return MyDialog(
                                title: "Choose gender",
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("Male"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _genderController.text = 'Male';
                                        });
                                      },
                                    ),
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("Female"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _genderController.text = 'Female';
                                        });
                                      },
                                    )
                                  ],
                                ));
                          });
                    },
                    readOnly: true,
                    validator: (value) {
                      if (value.toString().toLowerCase() != 'male' &&
                          value.toString().toLowerCase() != 'female') {
                        print(
                            "Gender = ${value.toString().toLowerCase()}, True?: ${value.toString().toLowerCase() != 'male' || value.toString().toLowerCase() != 'female'}");
                        return "Your gender can only be male or female";
                      }

                      return null;
                    },
                    hintText: 'Gender',
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                  ),
                ),

                //? 10 unit spacing
                const SizedBox(height: 24),

                Text(
                  "School information",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),
                //? SCHOOL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _schoolController,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyDialog(
                                title: "Choose school",
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("FUTO"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _schoolController.text =
                                              'Federal University of Technology, Owerri';
                                        });
                                      },
                                    ),
                                  ],
                                ));
                          });
                    },
                    hintText: 'School',
                    readOnly: true,
                    validator: (_) => null,
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                  ),
                ),

                //? 10 unit spacing
                const SizedBox(height: 10),

                //? DEPARTMENT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                      controller: _departmentController,
                      hintText: 'Department',
                      validator: (value) {
                        // if (value?.trim().isEmpty == true) {
                        //   return 'This field cannot be empty';
                        // }
                        return null;
                      }),
                ),

                //? 10 unit spacing
                const SizedBox(height: 10),
                //? LEVEL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _levelController,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyDialog(
                                title: "Choose level",
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //* 100 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("100"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '100 level';
                                        });
                                      },
                                    ),

                                    //* 200 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("200"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '200 level';
                                        });
                                      },
                                    ),

                                    //* 300 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("300"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '300 level';
                                        });
                                      },
                                    ),

                                    //* 400 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("400"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '400 level';
                                        });
                                      },
                                    ),

                                    //* 500 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("500"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '500 level';
                                        });
                                      },
                                    ),

                                    //* 600 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("600"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '600 level';
                                        });
                                      },
                                    ),

                                    //* 700 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("700"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '700 level';
                                        });
                                      },
                                    ),

                                    //* 800 LEVEL
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("800"),
                                      onTap: () {
                                        //! avigator.pop(context);
                                        context.pop();
                                        setState(() {
                                          _levelController.text = '800 level';
                                        });
                                      },
                                    ),
                                  ],
                                ));
                          });
                    },
                    hintText: 'Level',
                    readOnly: true,
                    validator: (_) => null,
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                  ),
                ),

                //? 10 unit spacing
                const SizedBox(height: 24),

                Text(
                  "Change password",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // CHANGE PASSWORD SECTION
                //? CURRENT PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _currentPasswordController,
                    validator: (value) {
                      if (value.toString() == '') {
                        return null;
                      } else {
                        return passwordValidator(value);
                      }
                    },
                    hintText: 'Current password',
                  ),
                ),

                //? 10 unit spacing
                const SizedBox(height: 10),

                //? NEW PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _newPasswordController,
                    obscureText: !_showPassword,
                    suffixIcon: _showPassword == false
                        ? const Icon(Icons.visibility_off_rounded)
                        : const Icon(Icons.visibility_rounded),
                    suffixOnpressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    validator: (value) {
                      if (value.toString() == '') {
                        return null;
                      } else {
                        return passwordValidator(value);
                      }
                    },
                    hintText: 'New password',
                  ),
                ),

                //? 24 unit spacing
                const SizedBox(height: 10),

                //? NEW CONFIRM PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: __newConfirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    suffixIcon: _showConfirmPassword == false
                        ? const Icon(Icons.visibility_off_rounded)
                        : const Icon(Icons.visibility_rounded),
                    suffixOnpressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (_newPasswordController.text.trim() != '') {
                        return signupConfirmPasswordValidator(
                            value, _newPasswordController.text.trim());
                      } else if (value.toString() == '') {
                        return null;
                      } else {
                        return signupConfirmPasswordValidator(
                            value, _newPasswordController.text.trim());
                      }
                    },
                    hintText: 'Confirm new password',
                  ),
                ),

                //? 24 unit spacing
                const SizedBox(height: 24),
              ]),
            ),
          )),
    );
  }

  Future<void> _getSingleImageFromSource({String? type}) async {
    final XFile? result = await widget.getSingleImageFromSource(context);

    if (result != null) {
      setState(() {
        type == 'profilePicture'
            ? _pickedProfilePicture = result
            : _pickedBannerImage = result;
      });
    } else if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No file recieved")));
    }
  }
}

class ChangeProfilePictureWidget extends StatelessWidget {
  const ChangeProfilePictureWidget(
      {super.key,
      required this.user,
      XFile? pickedImage,
      required this.onChangePressed})
      : _pickedBannerImage = pickedImage;

  final User user;
  final void Function() onChangePressed;
  final XFile? _pickedBannerImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyProfilePicture(
          user: user,
          pickedImage: _pickedBannerImage,
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onChangePressed,
              child: const CircleAvatar(
                backgroundColor: Colors.black,
                radius: 18,
                child: Icon(
                  Icons.add_a_photo_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ))
      ],
    );
  }
}
