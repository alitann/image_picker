import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/bloc/bloc/bottom_navigation_bloc.dart';
import '../model/collage_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

import '../bloc/bloc/image_picker_bloc.dart';
import '../service/pdf_creator.dart';

class CreateCollageView extends StatefulWidget {
  const CreateCollageView({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateCollageView> createState() => _CreateCollageViewState();
}

class _CreateCollageViewState extends State<CreateCollageView> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CImage> imageList = [];
  ImagePickerBloc? imagePickerBloc;
  BottomNavigationBloc? bottomNavigationBloc;
  final bool _isPdfLoaded = false;
  File? _pdfFile;

  @override
  void initState() {
    super.initState();
    imagePickerBloc = BlocProvider.of<ImagePickerBloc>(context); //context.read<ImagePickerBloc>();
    bottomNavigationBloc = context.read<BottomNavigationBloc>();
    // setStateLocal();
  }

  // void setStateLocal() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Collage'),
        actions: [
          IconButton(
              onPressed: (() {
                showImageSourceActionSheet(context);
              }),
              icon: const Icon(Icons.select_all))
        ],
      ),
      body: _isPdfLoaded
          ? Center(
              child: PdfView(path: _pdfFile!.path),
            )
          : BlocBuilder<ImagePickerBloc, ImagePickerState>(
              builder: (context, state) {
                if (state is ImagePickerLoadedState && state.images.isNotEmpty) {
                  imageList = state.images;
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
                  child: Text('No photos selected.'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Create Collage'),
        icon: const Icon(Icons.download_done_outlined),
        onPressed: () async {
          // final pdfCreater = CollageImageViewModel(imageList.cast<CollageImage>());
          final PdfService pdfService = PdfService(context, imageList);

          File? file = await pdfService.createPdfFile();
          if (file != null) {
            showSnackBar('Pdf file has been created succesfully.');
            bottomNavigationBloc?.add(TabBarChangeEvent(1));
          } else {
            showSnackBar('Pdf file has not been created. Please select at least 1 image.');
          }
        },
        // child: const Icon(Icons.arrow_right_outlined),
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<List<XFile?>>? getImage() async {
    // final XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
    final List<XFile>? pickedImage = await ImagePicker().pickMultiImage();
    if (pickedImage == null) return [];
    return pickedImage;
  }

  Future<void> addImageToImageList(ImageSource imageSource) async {
    List<XFile?>? file = await getImage();
    imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());
    if (file != null) {
      imageList.addAll(file.map((e) => CollageImage(e!.path)));

      // imageList.add(CollageImage(file.path, imageList.length));
      // print(imageList.length);
      imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
    }
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
      title: const Text('Camera'),
      onTap: () {
        Navigator.pop(context);
        addImageToImageList(ImageSource.camera);
      },
    );
  }

  ListTile androidGalleryActionSheet(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.photo_album),
      title: const Text('Gallery'),
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
        child: const Text('Camera'));
  }

  CupertinoActionSheetAction iosGalleryActionSheet(BuildContext context) {
    return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
          addImageToImageList(ImageSource.gallery);
        },
        child: const Text('Gallery'));
  }
}
