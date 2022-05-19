import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/bloc/bloc/bottom_navigation_bloc.dart';
import 'package:image_collage/bloc/bloc/pdf_file_bloc.dart';
import 'package:image_collage/constants/application_constants.dart';
import '../model/collage_image.dart';
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
  List<CImage> imageList = [];
  ImagePickerBloc? imagePickerBloc;
  BottomNavigationBloc? bottomNavigationBloc;
  PdfFileBloc? pdfFileBloc;

  @override
  void initState() {
    super.initState();
    imagePickerBloc = BlocProvider.of<ImagePickerBloc>(context); //context.read<ImagePickerBloc>();
    bottomNavigationBloc = context.read<BottomNavigationBloc>();
    pdfFileBloc = context.read<PdfFileBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ApplicationConstants.createCollage),
        actions: [
          IconButton(
              onPressed: (() {
                pdfFileBloc?.add(PdfFileResetRequest());
                showImageSourceActionSheet(context);
              }),
              icon: const Icon(Icons.add_photo_alternate_outlined))
        ],
      ),
      body: BlocBuilder<PdfFileBloc, PdfFileState>(
        builder: (context, pdfState) {
          if (pdfState is PdfFileCreated) {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    bottomNavigationBloc?.add(TabBarChangeEvent(1));
                    imagePickerBloc?.add(MutlipleSelectImageResetEvent());
                    pdfFileBloc?.add(PdfFileResetRequest());
                  },
                  child: const Text(ApplicationConstants.showPdfFile),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    imagePickerBloc?.add(MutlipleSelectImageResetEvent());
                    pdfFileBloc?.add(PdfFileResetRequest());
                    imageList = [];
                  },
                  child: const Text(ApplicationConstants.newCollage),
                ),
              ],
            ));
          } else if (pdfState is PdfFileError) {
            return Center(
              child: Text(pdfState.errorMessage),
            );
          } else {
            return BlocBuilder<ImagePickerBloc, ImagePickerState>(
              builder: (context, state) {
                if (state is ImagePickerLoadedState && state.images.isNotEmpty) {
                  imageList = state.images;
                  return GridView.builder(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.images.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 201, 201, 201), borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              image: FileImage(File(state.images[index].path)),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      });
                } else if (state is ImagePickerLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const Center(
                  child: Text(ApplicationConstants.noSelectedPhotos),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(ApplicationConstants.createCollage),
        icon: const Icon(Icons.download_done_outlined),
        onPressed: () async {
          BlocProvider.of<PdfFileBloc>(context).add(PdfFileCreateRequest(imageList, context));
        },
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<List<XFile?>>? getImageFromGallery() async {
    final List<XFile>? pickedImage = await ImagePicker().pickMultiImage();
    if (pickedImage == null) return [];
    return pickedImage;
  }

  Future<XFile?> getImageFromCamera() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    return pickedImage;
  }

  Future<void> addImageToImageList(ImageSource imageSource) async {
    List<XFile?>? fileList;
    XFile? file;

    imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());

    if (imageSource == ImageSource.camera) {
      file = await getImageFromCamera();
      if (file != null) {
        imageList.add(CollageImage(path: file.path));
      } else {
        imagePickerBloc?.add(MutlipleSelectImageResetEvent());
      }
    } else {
      fileList = await getImageFromGallery();
      imageList.addAll(fileList!.map((e) => CollageImage(path: e!.path)));
    }

    imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
  }

  void showImageSourceActionSheet(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [iosGalleryActionSheet(context), iosCameraActionSheet(context)],
              ));
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(
                children: [androidCameraActionSheet(context), androidGalleryActionSheet(context)],
              ));
    }
  }

  ListTile androidCameraActionSheet(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera_alt),
      title: const Text(ApplicationConstants.camera),
      onTap: () {
        Navigator.pop(context);
        addImageToImageList(ImageSource.camera);
      },
    );
  }

  ListTile androidGalleryActionSheet(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.photo_album),
      title: const Text(ApplicationConstants.gallery),
      onTap: () async {
        Navigator.pop(context);
        addImageToImageList(ImageSource.gallery);
      },
    );
  }

  CupertinoActionSheetAction iosCameraActionSheet(BuildContext context) {
    return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
          addImageToImageList(ImageSource.camera);
        },
        child: const Text(ApplicationConstants.camera));
  }

  CupertinoActionSheetAction iosGalleryActionSheet(BuildContext context) {
    return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
          addImageToImageList(ImageSource.gallery);
        },
        child: const Text(ApplicationConstants.gallery));
  }
}
