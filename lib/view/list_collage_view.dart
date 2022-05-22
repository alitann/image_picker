import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/core/snackbar.dart';
import '../bloc/bloc/collage_list_bloc.dart';
import '../constants/application_constants.dart';
import 'pdf_viewer.dart';
import 'package:share_plus/share_plus.dart';

class ListCollageView extends StatefulWidget {
  const ListCollageView({
    Key? key,
  }) : super(key: key);

  @override
  State<ListCollageView> createState() => _ListCollageViewState();
}

class _ListCollageViewState extends State<ListCollageView> {
  CollageListBloc? collageListBloc;
  @override
  void initState() {
    super.initState();
    collageListBloc = context.read<CollageListBloc>();
    collageListBloc?.add(CollageListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BlocBuilder<CollageListBloc, CollageListState>(
        builder: (context, state) {
          if (state is CollageListLoading) {
            return _handleCollageListLoading();
          } else if (state is CollageListLoaded) {
            return _buildListView(state);
          }

          return _doNothing();
        },
      ),
    );
  }

  SizedBox _doNothing() => const SizedBox.shrink();

  Center _handleCollageListLoading() => const Center(child: CircularProgressIndicator());

  ListView _buildListView(CollageListLoaded state) {
    return ListView.builder(
        itemCount: state.imagePdfFiles.length,
        itemBuilder: (context, index) {
          final pdfFile = state.imagePdfFiles[index];
          final title = pdfFile.path.split('/').last.toString();
          return _buildListTile(context, title, pdfFile);
        });
  }

  ListTile _buildListTile(BuildContext context, String title, File pdfFile) {
    return ListTile(
      trailing: _buildListTileTrailing(context, title, pdfFile),
      title: Text('${ApplicationConstants.myCollage} ${title.substring(0, title.length - 7)}'),
      subtitle: Text(title),
    );
  }

  Row _buildListTileTrailing(BuildContext context, String title, File pdfFile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PdfViewerView(title: title, pdfFile: pdfFile)),
            );
          },
          child: const Icon(Icons.slideshow_outlined),
        ),
        const SizedBox(width: 20),
        InkWell(
            child: const Icon(Icons.share_outlined),
            onTap: () async {
              Share.shareFiles([pdfFile.path], text: ApplicationConstants.shareDescription);
            }),
        const SizedBox(width: 20),
        InkWell(
            child: const Icon(Icons.delete_forever_outlined),
            onTap: () async {
              _showConfirmationDialog(pdfFile, context);
            })
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: BlocConsumer<CollageListBloc, CollageListState>(
        listener: (context, state) {
          if (state is CollageListDeleted) {
            CommonSnackbar.buildSnackbar(context, ApplicationConstants.pdfFileDeletedInfoMessage);
          } else if (state is CollageListError) {
            CommonSnackbar.buildSnackbar(context, state.errorMessage.toString());
          }
        },
        builder: (context, state) {
          return const Text(ApplicationConstants.collageList);
        },
      ),
    );
  }

  Future<void> _showConfirmationDialog(File pdfFile, BuildContext contextMain) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(ApplicationConstants.deleteFile),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(ApplicationConstants.deleteConfirmationDescription),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(ApplicationConstants.confirm),
              onPressed: () {
                collageListBloc?.add(CollageListDeleteEvent(pdfFile));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(ApplicationConstants.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
