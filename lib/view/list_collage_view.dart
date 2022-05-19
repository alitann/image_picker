import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
        title: const Text(ApplicationConstants.collageList),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BlocBuilder<CollageListBloc, CollageListState>(
          builder: (context, state) {
            if (state is CollageListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CollageListLoaded) {
              return ListView.builder(
                  itemCount: state.imagePdfFiles.length,
                  itemBuilder: (context, index) {
                    final pdfFile = state.imagePdfFiles[index];
                    final title = pdfFile.path.split('/').last.toString();
                    return ListTile(
                      // leading: const Icon(Icons.list),
                      trailing: Row(
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
                      ),
                      title: Text('${ApplicationConstants.myCollage} ${title.substring(0, title.length - 7)}'),
                      subtitle: Text(title),
                    );
                  });
            } else if (state is CollageListError) {
              return Center(child: Text(state.errorMessage.toString()));
            }
            return const SizedBox.shrink();
          },
        ),
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
