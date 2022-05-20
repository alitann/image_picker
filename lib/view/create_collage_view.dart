import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/core/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../bloc/bloc/bottom_navigation_bloc.dart';
import '../bloc/bloc/image_picker_bloc.dart';
import '../bloc/bloc/pdf_file_bloc.dart';
import '../constants/application_constants.dart';
import '../model/collage_image.dart';

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
  int imageQuality = 100;

  final data = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    initBloc();
  }

  void initBloc() {
    imagePickerBloc = BlocProvider.of<ImagePickerBloc>(context);
    bottomNavigationBloc = BlocProvider.of<BottomNavigationBloc>(context);
    pdfFileBloc = BlocProvider.of<PdfFileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text(ApplicationConstants.createCollage),
      icon: const Icon(Icons.download_done_outlined),
      onPressed: () async {
        pdfFileBloc?.add(PdfFileCreateRequest(imageList, context));
      },
    );
  }

  BlocBuilder<PdfFileBloc, PdfFileState> _buildBody() {
    return BlocBuilder<PdfFileBloc, PdfFileState>(
      builder: (context, pdfState) {
        if (pdfState is PdfFileLoading) {
          return handlePdfFileLoadingState();
        } else if (pdfState is PdfFileCreated) {
          return handlePdfFileCreatedState();
        } else if (pdfState is PdfFileError) {
          return handlePdfFileErrorState(pdfState);
        } else {
          return handleImagePickerStates();
        }
      },
    );
  }

  BlocBuilder<ImagePickerBloc, ImagePickerState> handleImagePickerStates() {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        if (state is ImagePickerLoadedState && state.images.isNotEmpty) {
          imageList = state.images;
          return handleImageLoadedState(state);
        } else if (state is ImagePickerLoadingState) {
          return handleImageLoadingState();
        } else if (state is ImagePickerErrorState) {
          return handleImagePickerErrorState(state);
        } else if (state is ImagePickerQualityState) {
          imageQuality = state.imageQuality;
          imagePickerBloc?.add(MutlipleSelectImageResetEvent());
        }

        return handleImageInitialState();
      },
    );
  }

  Center handleImageInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Image Quality'),
          Slider(
              label: (imageQuality ~/ 1).toString(),
              value: imageQuality.toDouble(),
              divisions: 10,
              max: 100.0,
              min: 0.0,
              onChanged: (val) {
                imageQuality = val.toInt();
                imagePickerBloc?.add(ImagePickerSetQualityEvent((imageQuality ~/ 1)));
              }),
          const SizedBox(height: 20),
          const Text(ApplicationConstants.noSelectedPhotos),
        ],
      ),
    );
  }

  Center handleImageLoadingState() => const Center(child: CircularProgressIndicator());
  Center handlePdfFileLoadingState() => const Center(child: CircularProgressIndicator());

  Widget handleImageLoadedState(ImagePickerLoadedState state) {
    return Center(
      // use ReorderableGridView.count() when version >= 2.0.0
      // else use ReorderableGridView()
      child: ReorderableGridView.count(
        padding: const EdgeInsets.all(20),
        addSemanticIndexes: true,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            final element = imageList.removeAt(oldIndex);
            imageList.insert(newIndex, element);
          });
        },
        children: imageList.map((e) => _imageCard(state, imageList.indexOf(e))).toList(),
      ),
    );
  }

  Widget buildItem(String text) {
    return Card(
      key: ValueKey(text),
      child: Text(text),
    );
  }

  ClipRRect _imageCard(ImagePickerLoadedState state, index) {
    return ClipRRect(
      key: ValueKey(index),
      borderRadius: BorderRadius.circular(8.0),
      child: Image(
        image: FileImage(File(state.images[index].path)),
        fit: BoxFit.cover,
      ),
    );
  }

  // GridView handleImageLoadedState(ImagePickerLoadedState state) {
  // return GridView.builder(
  //     primary: false,
  //     padding: const EdgeInsets.all(20),
  //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //       maxCrossAxisExtent: 150,
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //     ),
  //     itemCount: state.images.length,
  //     itemBuilder: (BuildContext ctx, index) {
  //       return ClipRRect(
  //         borderRadius: BorderRadius.circular(8.0),
  //         child: Image(
  //           image: FileImage(File(state.images[index].path)),
  //           fit: BoxFit.cover,
  //         ),
  //       );
  //     });
  // }

  // Widget handleImageLoadedState(ImagePickerLoadedState state) {
  //   return DragAndDropGridView(
  //       controller: _scrollController,
  //       primary: false,
  //       padding: const EdgeInsets.all(20),
  //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //         maxCrossAxisExtent: 150,
  //         crossAxisSpacing: 10,
  //         mainAxisSpacing: 10,
  //       ),
  //       itemCount: state.images.length,
  //       itemBuilder: (BuildContext ctx, index) {
  //         return Container(
  //           alignment: Alignment.center,
  //           decoration:
  //               BoxDecoration(color: const Color.fromARGB(255, 201, 201, 201), borderRadius: BorderRadius.circular(8)),
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(8.0),
  //             child: Image(
  //               image: FileImage(File(state.images[index].path)),
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //         );
  //       },
  //       onReorder: (oldIndex, newIndex) {
  //         final tempImage = imageList[newIndex];
  //         imageList[newIndex] = imageList[oldIndex];
  //         imageList[oldIndex] = tempImage;
  //         imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
  //       },
  //       onWillAccept: (oldIndex, newIndex) {
  //         return true;
  //       });
  // }

  Center handlePdfFileErrorState(PdfFileError pdfState) {
    return Center(
      child: Text(pdfState.errorMessage),
    );
  }

  Center handleImagePickerErrorState(ImagePickerErrorState imagePickerState) {
    return Center(
      child: Text(imagePickerState.errorMessage),
    );
  }

  Center handlePdfFileCreatedState() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            pdfFileBloc?.add(PdfFileResetRequest());
            bottomNavigationBloc?.add(TabBarChangeEvent(1));
            imagePickerBloc?.add(MutlipleSelectImageResetEvent());
          },
          child: const Text(ApplicationConstants.showPdfFile),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            _resetView();
          },
          child: const Text(ApplicationConstants.newCollage),
        ),
      ],
    ));
  }

  void _resetView() {
    imagePickerBloc?.add(MutlipleSelectImageResetEvent());
    pdfFileBloc?.add(PdfFileResetRequest());
    imageList = [];
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(ApplicationConstants.createCollage),
      actions: [_buildAppBarActionReset(context), _buildAppBarActionCreate(context)],
    );
  }

  Widget _buildAppBarActionReset(BuildContext context) {
    return IconButton(
        onPressed: (() {
          _resetView();
        }),
        icon: const Icon(Icons.refresh_outlined));
  }

  Widget _buildAppBarActionCreate(BuildContext context) {
    return BlocConsumer<PdfFileBloc, PdfFileState>(
      listener: (context, state) {
        if (state is PdfFileCreated) {
          CommonSnackbar.buildSnackbar(context, ApplicationConstants.pdfFileCreatedInfoMessage);
        }
      },
      builder: (context, state) {
        return IconButton(
            onPressed: (() {
              pdfFileBloc?.add(PdfFileResetRequest());
              showImageSourceActionSheet(context);
            }),
            icon: const Icon(Icons.add_photo_alternate_outlined));
      },
    );
  }

  Future<List<XFile?>>? getImageFromGallery() async {
    final List<XFile>? pickedImage = await ImagePicker().pickMultiImage(imageQuality: imageQuality);
    if (pickedImage == null) return [];
    return pickedImage;
  }

  Future<XFile?> getImageFromCamera() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: imageQuality);
    return pickedImage;
  }

  Future<void> addImageToImageList(ImageSource imageSource) async {
    List<XFile?>? fileList;
    XFile? file;

    if (imageSource == ImageSource.camera) {
      await handleGetImageFromCamera(file);
    } else {
      await handleGetImageFromGallery(fileList);
    }
  }

  Future<void> handleGetImageFromGallery(List<XFile?>? fileList) async {
    fileList = await getImageFromGallery();
    imageList.addAll(fileList!.map((e) => CollageImage(path: e!.path)));
    imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
  }

  Future<void> handleGetImageFromCamera(XFile? file) async {
    file = await getImageFromCamera();
    if (file != null) {
      imageList.add(CollageImage(path: file.path));
      imagePickerBloc?.add(MutlipleSelectImageEvent(images: imageList));
    } else {
      imagePickerBloc?.add(MutlipleSelectImageResetEvent());
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
      title: const Text(ApplicationConstants.camera),
      onTap: () {
        _setImageLoadingState();
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
        _setImageLoadingState();
        Navigator.pop(context);
        addImageToImageList(ImageSource.gallery);
      },
    );
  }

  CupertinoActionSheetAction iosCameraActionSheet(BuildContext context) {
    return CupertinoActionSheetAction(
        onPressed: () {
          _setImageLoadingState();
          Navigator.pop(context);
          addImageToImageList(ImageSource.camera);
        },
        child: const Text(ApplicationConstants.camera));
  }

  CupertinoActionSheetAction iosGalleryActionSheet(BuildContext context) {
    return CupertinoActionSheetAction(
        onPressed: () {
          _setImageLoadingState();

          Navigator.pop(context);
          addImageToImageList(ImageSource.gallery);
        },
        child: const Text(ApplicationConstants.gallery));
  }

  void _setImageLoadingState() {
    imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());
  }
}
