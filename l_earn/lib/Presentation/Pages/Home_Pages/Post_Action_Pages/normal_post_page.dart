import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/Presentation/components/display_image.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
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

  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    //? Request focus
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _focusNode.requestFocus();
      },
    );

    return Scaffold(
        appBar: widget.buildAppBar(context, actions: [
          Align(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                return MyContainerButton(
                    text: 'post',
                    loading: state is CreatingNewPost,
                    onPressed: () {
                      print("::: Posting your content ::::");
                      final String text = _postText.text.trim();

                      if (text == '') {
                        print("can't make a post without a body");
                        return;
                      }

                      final Map<String, dynamic> post = {
                        'text': text,
                      };

                      if (_pickedImage != null) {
                        post.addAll(
                            {'addon': 'image', 'image': _pickedImage!.path});
                      }

                      context.read<PostCubit>().createNewPosts(
                          context.read<AuthCubit>().state.user!.token!, post);
                    });
              }),
            ),
          )
        ]),
        floatingActionButton: CompositedTransformTarget(
          link: _layerLink,
          child: FloatingActionButton(
            backgroundColor: AppColor.mainColorBlack,
            onPressed: _getSingleImageFromSource,
            child: OverlayPortal(
              controller: _overlayPortalController,
              overlayChildBuilder: (context) {
                return Align(
                    child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: Offset(-200, -120),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: AppColor.mainColorBlack.withOpacity(0.25),
                          spreadRadius: 3,
                          blurRadius: 3)
                    ]),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ListTile(
                        //   leading: Icon(Icons.camera), title: Text("Camera"),),
                        // Divider(),
                        // ListTile(leading: Icon(Icons.image), title: Text("Gallery"))
                      ],
                    ),
                  ),
                ));
              },
              child: const Icon(Icons.image),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //? TEXT
              MyTextField(
                hintText: "Write something... #hashtag",
                focusNode: _focusNode,
                controller: _postText,
                maxLines: 20,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                textFieldType: TextFieldType.post,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Tip: Include at least three hashtags that describes your post",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ),

              //? IMAGE

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DisplayImage(pickedImage: _pickedImage),
              )
            ],
          ),
        ));
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
