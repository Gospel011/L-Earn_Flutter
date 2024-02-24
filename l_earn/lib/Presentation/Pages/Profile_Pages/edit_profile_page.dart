import 'package:flutter/material.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/mixins.dart';

class EditProfilePage extends StatefulWidget with AppBarMixin {
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
  late final User user;

final _fo                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              rmKey = GlobalKey<FormState>();




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
    _levelController.text = user.level.toString() == 'null' ? '' : user.level.toString();
    _departmentController.text = user.department.toString() == 'null' ? '' : user.department.toString();
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.buildAppBar(context, title: 'Edit profile', actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: MyContainerButton(
                text: 'Edit',
                onPressed: () {
                  print('Edit profile pressed');
                }),
          )
        ]),
        body: SingleChildScrollView(
          child: Column(children: [
            //? BANNER
            const ImageLoadingPlaceHolderWidget(
              width: double.maxFinite,
              height: 150,
              placeHolderText: 'Click to add image',
            ),

            const SizedBox(
              height: 10,
            ),

            //? PROFILE PICTURE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ChangeProfilePictureWidget(
                user: user,
                onChangePressed: () {
                  //TODO: IMPLEMENT IMAGE PICKER
                  print('::: C H A N G E   I M A G E   P R E S S E D :::');
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
                          controller: _firstNameController,
                          validator: firstNameFieldValidator)),

                  //? 10 unit spacing
                  const SizedBox(width: 10),

                  Expanded(
                      child: MyTextFormField(
                          hintText: 'Last name',
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
                  controller: _emailController, hintText: 'Email', validator: emailValidator),
            ),

            //? 10 unit spacing
            const SizedBox(height: 10),

            //? HANDLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyTextFormField(
                  hintText: 'Handle',
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
                      builder: (context) {
                        return MyDialog(
                            title: "Choose gender",
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("Male"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _genderController.text = 'Male';
                                    });
                                  },
                                ),
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("Female"),
                                  onTap: () {
                                    Navigator.pop(context);
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
                validator: (_) => null,
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
                            title: "Choose gender",
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("FUTO"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _schoolController.text = 'Federal University of Technology, Owerri';
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
              child: MyTextFormField(controller: _departmentController, hintText: 'Department', validator: (value) {
                if(value?.trim().isEmpty == true) {
                  return 'This field cannot be empty';
                }
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
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("100"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '100 level';
                                    });
                                  },
                                ),

                                //* 200 LEVEL 
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("200"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '200 level';
                                    });
                                  },
                                ),

                                //* 300 LEVEL
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("300"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '300 level';
                                    });
                                  },
                                ),

                                //* 400 LEVEL
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("400"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '400 level';
                                    });
                                  },
                                ),

                                //* 500 LEVEL
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("500"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '500 level';
                                    });
                                  },
                                ),

                                //* 600 LEVEL
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("600"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '600 level';
                                    });
                                  },
                                ),

                                //* 700 LEVEL
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("700"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _levelController.text = '700 level';
                                    });
                                  },
                                ),

                                //* 800 LEVEL
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text("800"),
                                  onTap: () {
                                    Navigator.pop(context);
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
              child: MyTextFormField(controller: _currentPasswordController, validator: passwordValidator, hintText: 'Current password',),
            ),

            //? 10 unit spacing
            const SizedBox(height: 10),

            //? NEW PASSWORD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyTextFormField(controller: _newPasswordController, validator: passwordValidator, hintText: 'New password',),
            ),

            //? 10 unit spacing
            const SizedBox(height: 24),
          ]),
        ));
  }
}

class ChangeProfilePictureWidget extends StatelessWidget {
  const ChangeProfilePictureWidget(
      {super.key, required this.user, required this.onChangePressed});

  final User user;
  final void Function() onChangePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyProfilePicture(user: user),
        Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onChangePressed,
              child: const CircleAvatar(
                backgroundColor: Colors.black,
                radius: 20,
                child: Icon(
                  Icons.add_a_photo_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ))
      ],
    );
  }
}
