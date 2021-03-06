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
  static const int imgQuality = 100;
  int imageQuality = 100;

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
          handleImagePickerQualityState(state);
        }
        return handleImageInitialState();
      },
    );
  }

  void handleImagePickerQualityState(ImagePickerQualityState state) {
    imageQuality = state.imageQuality;
    imagePickerBloc?.add(ImagePickerResetEvent());
  }

  Center handleImageInitialState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Column(
              children: [
                const Text(ApplicationConstants.imageQualityTitle),
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
              ],
            ),
          ),
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
      child: ReorderableGridView.count(
        padding: const EdgeInsets.all(20),
        addSemanticIndexes: true,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        onReorder: (oldIndex, newIndex) {
          final element = imageList.removeAt(oldIndex);
          imageList.insert(newIndex, element);
          imagePickerBloc?.add(ImagePickerSelectEvent(images: imageList));
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
            imagePickerBloc?.add(ImagePickerResetEvent());
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

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text(ApplicationConstants.createCollage),
      icon: const Icon(Icons.download_done_outlined),
      onPressed: () async {
        pdfFileBloc?.add(PdfFileCreateRequest(imageList, context));
      },
    );
  }

  void _resetView() {
    pdfFileBloc?.add(PdfFileResetRequest());
    imagePickerBloc?.add(const ImagePickerSetQualityEvent((imgQuality)));
    imageList = [];
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
    imagePickerBloc?.add(ImagePickerSelectEvent(images: imageList));
  }

  Future<void> handleGetImageFromCamera(XFile? file) async {
    file = await getImageFromCamera();
    if (file != null) {
      imageList.add(CollageImage(path: file.path));
      imagePickerBloc?.add(ImagePickerSelectEvent(images: imageList));
    } else {
      imagePickerBloc?.add(ImagePickerResetEvent());
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
    imagePickerBloc?.add(ImagePickerLoadingEvent());
  }
}
