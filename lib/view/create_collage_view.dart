import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/core/snackbar.dart';
import 'package:image_picker/image_picker.dart';

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
        }
        return handleImageInitialState();
      },
    );
  }

  Center handleImageInitialState() {
    return const Center(
      child: Text(ApplicationConstants.noSelectedPhotos),
    );
  }

  Center handleImageLoadingState() => const Center(child: CircularProgressIndicator());
  Center handlePdfFileLoadingState() => const Center(child: CircularProgressIndicator());

  GridView handleImageLoadedState(ImagePickerLoadedState state) {
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
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 201, 201, 201), borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: FileImage(File(state.images[index].path)),
                fit: BoxFit.fill,
              ),
            ),
          );
        });
  }

  Center handlePdfFileErrorState(PdfFileError pdfState) {
    return Center(
      child: Text(pdfState.errorMessage),
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
            imagePickerBloc?.add(MutlipleSelectImageResetEvent());
            pdfFileBloc?.add(PdfFileResetRequest());
            imageList = [];
          },
          child: const Text(ApplicationConstants.newCollage),
        ),
      ],
    ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(ApplicationConstants.createCollage),
      actions: [_buildAppBarAcitons(context)],
    );
  }

  Widget _buildAppBarAcitons(BuildContext context) {
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
    } else {
      imagePickerBloc?.add(MutlipleSelectImageResetEvent());
    }
  }

  void showImageSourceActionSheet(BuildContext context) {
    imagePickerBloc?.add(MutlipleSelectImageLoadingEvent());

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
