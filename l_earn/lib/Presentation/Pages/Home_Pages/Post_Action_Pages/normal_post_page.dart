import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';

import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/Presentation/components/display_image.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';

import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/enums.dart';

import '../../../../utils/mixins.dart';
import '../../../../utils/colors.dart';

class MakePostPage extends StatefulWidget with AppBarMixin, ImageMixin {
  const MakePostPage({super.key});

  @override
  State<MakePostPage> createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  final TextEditingController _postText = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    //? Request focus
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _focusNode.requestFocus();
      },
    );

    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state is NewPostCreated) {
          //! avigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          context.goNamed(AppRoutes.home);
        }
      },
      child: Scaffold(
          appBar: widget.buildAppBar(context,
              automaticallyImplyLeading: Platform.isWindows,
              title: 'Make Post',
              actions: [
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: BlocBuilder<PostCubit, PostState>(
                        builder: (context, state) {
                      return MyContainerButton(
                          text: 'post',
                          loading: state is CreatingNewPost,
                          onPressed: () {
                            print("::: Posting your content ::::");
                            if (state is CreatingNewPost) return;

                            final String text = _postText.text.trim();

                            if (text == '') {
                              context.read<PostCubit>().emitNewPostsFailed(
                                  title: 'Failed',
                                  content:
                                      'Can\'t create post with empty body');
                              return;
                            }

                            final Map<String, dynamic> post = {
                              'text': text,
                            };

                            if (_pickedImage != null) {
                              post.addAll({
                                'addon': 'image',
                                'image': _pickedImage!.path
                              });
                            }

                            context.read<PostCubit>().createNewPosts(
                                context.read<AuthCubit>().state.user!.id!,
                                context.read<AuthCubit>().state.user!.token!,
                                post);
                          });
                    }),
                  ),
                )
              ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.mainColorBlack,
            onPressed: _getSingleImageFromSource,
            child: const Icon(Icons.image),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                //? TEXT
                MyTextField(
                  hintText: "Write something...",
                  focusNode: _focusNode,
                  controller: _postText,
                  maxLines: 20,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  textFieldType: TextFieldType.post,
                ),

                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Text(
                //     "Tip: Include at least three hashtags that describes your post",
                //     style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                //   ),
                // ),

                //? IMAGE

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DisplayImage(pickedImage: _pickedImage),
                )
              ],
            ),
          )),
    );
  }

  Future<void> _getSingleImageFromSource() async {
    _pickedImage = await widget.getSingleImageFromSource(context);

    if (_pickedImage != null) {
      setState(() {});
    } else if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No file recieved")));
    }
  }
}
