import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/file_model.dart';
import 'package:l_earn/Presentation/components/display_image.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';
import 'package:l_earn/Presentation/components/my_price_container.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/mixins.dart';

class CreateTutorialPage extends StatefulWidget
    with AppBarMixin, ImageMixin, PriceParserMixin {
  const CreateTutorialPage(
      {super.key,
      this.thumbnailUrl,
      this.title = '',
      this.description = '',
      this.genre = '',
      this.price = ''});

  final String title;
  final String description;
  final String genre;
  final String price;
  final String? thumbnailUrl;

  @override
  State<CreateTutorialPage> createState() => _CreateTutorialPageState();
}

class _CreateTutorialPageState extends State<CreateTutorialPage> {
  XFile? _pickedImage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _genreController.text = widget.genre;
    _priceController.text = widget.price;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _genreController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        textTheme: TextTheme(
            bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.mainColorBlack)),
        inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: InputBorder.none));

    return BlocListener<ContentCubit, ContentState>(
        listener: (context, state) async {
          print("::::: $state :::::");

          //? SHOW DIALOG FOR INITIALIZING CONTENT FAILED
          if (state is InitializingContentFailed) {
            showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                      title: state.error!.title, content: state.error!.content);
                });
          }

          //? SHOW DIALOG FOR SUCCESSFUL CREATION
          else if (state is ContentCreated) {
            await showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                      title: 'Successful',
                      content:
                          'Your book has been created.\nTo add chapters, go to your profile and click on the three dots above your book.');
                });

            Navigator.pushNamed(context, '/profile-page',
                arguments: context.read<AuthCubit>().state.user!);
          }
        },
        child: Scaffold(
            appBar: widget.buildAppBar(context, title: 'Create Book', actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: BlocBuilder<ContentCubit, ContentState>(
                    builder: (context, state) {
                  return MyContainerButton(
                      text: 'Create',
                      loading: state is InitializingContent,
                      onPressed: () {
                        print(
                            "::: G E N R E  IS  ${_genreController.text.split(', ').length}");
                        if (state is InitializingContent) return;

                        if (_pickedImage?.path == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const MyDialog(
                                    title: 'Fail',
                                    content:
                                        'Please choose an image for your book cover');
                              });

                          return;
                        } else if (_titleController.text.trim() == '' ||
                            _descriptionController.text.trim() == '') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const MyDialog(
                                    title: 'Fail',
                                    content:
                                        'Your title and description cannot be empty');
                              });

                          return;
                        } else if (_genreController.text.trim() == '' ||
                            _genreController.text.split(', ').length < 3) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const MyDialog(
                                    title: 'Fail',
                                    content:
                                        'Please add atleast three genres that describe your book');
                              });

                          return;
                        }

                        final Map<String, dynamic> details = {
                          'file':
                              File(name: 'thumbnail', path: _pickedImage!.path),
                          'title': _titleController.text.trim(),
                          'price': _priceController.text == ''
                              ? '0'
                              : _priceController.text,
                          'tags':
                              _genreController.text.toLowerCase().split(', '),
                          'description': _descriptionController.text.trim()
                          // '[{"insert": "${_descriptionController.text.trim()}\n"}]'
                        };
                        print("About to create book with details: $details");

                        //? ASKING BLOC TO CREATE THE CONTENT
                        context.read<ContentCubit>().initializeBook(
                            context.read<AuthCubit>().state.user?.token,
                            details);
                      });
                }),
              )
            ]),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  //? Thumbnail
                  widget.thumbnailUrl != null
                      ? MyImageWidget(
                          image: widget.thumbnailUrl!,
                          borderRadius: 0,
                        )
                      : _pickedImage == null
                          ? GestureDetector(
                              onTap: _getSingleImageFromSource,
                              child: const ImageLoadingPlaceHolderWidget(
                                  width: double.maxFinite,
                                  height: 200,
                                  placeHolderText:
                                      'Click to add book cover image'))
                          : GestureDetector(
                              onTap: _getSingleImageFromSource,
                              child: DisplayImage(
                                pickedImage: _pickedImage,
                                borderRadius: 0,
                                minHeight: 300,
                              ),
                            ),

                  //? Title
                  Theme(
                    data: themeData,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MyTextField(
                        controller: _titleController,
                        maxLines: null,
                        hintText: 'Title',
                        inputFormatters: [LengthLimitingTextInputFormatter(75)],
                        maxLength: 75,
                      ),
                    ),
                  ),

                  //? Price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MyDialog(
                                      title: 'Add a price tag to your book',
                                      content: MyTextField(
                                        controller: _priceController,
                                        hintText: '\u20A6x,xxx',
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4)
                                        ],
                                      ),
                                      actions: [
                                        MyContainerButton(
                                            text: 'Add',
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              setState(() {});

                                              Navigator.pop(context);
                                            })
                                      ],
                                    );
                                  });
                            },
                            child: MyPriceContainer(
                                price: _priceController.text == ''
                                    ? 'Add a price tag'
                                    : widget
                                        .parsePrice(_priceController.text))),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  //? Genres
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: MyTextField(
                      controller: _genreController,
                      hintText: 'genre1, genre2, genre3',
                    ),
                  ),

                  //? Hint
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Tip: Add atleast three genres to your book',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  //? Description
                  Theme(
                    data: ThemeData(
                        textTheme: TextTheme(
                            bodyMedium: Theme.of(context).textTheme.bodyMedium),
                        inputDecorationTheme: const InputDecorationTheme(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: InputBorder.none)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MyTextField(
                        controller: _descriptionController,
                        hintText: 'Add Description',
                        maxLines: null,
                        minLines: 5,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(750)
                        ],
                        maxLength: 750,
                      ),
                    ),
                  ),

                  //? Bottom Spacing
                  const SizedBox(height: 24)
                ],
              ),
            )));
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
