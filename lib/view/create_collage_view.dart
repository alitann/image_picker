import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/bloc/image_picker_bloc.dart';

class CreateCollageView extends StatefulWidget {
  const CreateCollageView({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateCollageView> createState() => _CreateCollageViewState();
}

class _CreateCollageViewState extends State<CreateCollageView> {
  List<XFile?> imageList = [];
  ImagePickerBloc? imagePickerBloc;

  @override
  void initState() {
    super.initState();
    imagePickerBloc = context.read<ImagePickerBloc>();
    // imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Collage'),
        actions: [
          IconButton(
              onPressed: (() {
                _showImageSourceActionSheet(context);
              }),
              icon: const Icon(Icons.select_all))
        ],
      ),
      body: BlocBuilder<ImagePickerBloc, ImagePickerState>(
        builder: (context, state) {
          if (state is ImagePickerLoadedState && state.images!.isNotEmpty) {
            return GridView.builder(
                primary: false,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  // childAspectRatio: 3 / 2,
                  // crossAxisSpacing: 20,
                  // mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.images!.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 201, 201, 201), borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        image: FileImage(File(state.images![index]!.path)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                });
          } else if (state is ImagePickerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text('No photos selected.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.download_for_offline),
      ),
    );
  }

  Future<XFile?>? getImage({required ImageSource imageSource}) async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage == null) return null;
    return pickedImage;
  }

  void _showImageSourceActionSheet(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () async {
                        Navigator.pop(context);
                        XFile? file = await getImage(imageSource: ImageSource.gallery);
                        // addImageToImageList(file);
                        imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());

                        if (file == null) return;
                        print(file.path);
                        imageList.add(file);
                        print(imageList.length);
                        imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
                      },
                      child: const Text('Gallery')),
                  CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Camera'))
                ],
              ));
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_album),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(context);
                      XFile? file = await getImage(imageSource: ImageSource.gallery);
                      imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());
                      if (file == null) return;
                      print(file.path);
                      imageList.add(file);
                      print(imageList.length);
                      imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
                    },
                  ),
                ],
              ));
    }
  }

  void addImageToImageList(XFile? file) {
    if (file == null) return;
    print(file.path);
    imageList.add(file);
    print(imageList.length);
    imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
  }
}
