import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/bloc/bloc/collage_list_bloc.dart';
import 'package:image_collage/view/pdf_viewer.dart';
import 'package:share_plus/share_plus.dart';

class ListCollageView extends StatefulWidget {
  const ListCollageView({
    Key? key,
  }) : super(key: key);

  @override
  State<ListCollageView> createState() => _ListCollageViewState();
}

class _ListCollageViewState extends State<ListCollageView> {
  @override
  void initState() {
    super.initState();
    CollageListBloc collageListBloc = context.read<CollageListBloc>();
    collageListBloc.add(CollageListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collage List'),
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
                    final imageFile = state.imagePdfFiles[index];
                    final title = imageFile.path.split('/').last.toString();
                    return ListTile(
                      // leading: const Icon(Icons.list),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PdfViewerView(title: title, pdfFile: imageFile)),
                              );
                            },
                            child: const Icon(Icons.slideshow_outlined),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                              child: const Icon(Icons.share_outlined),
                              onTap: () async {
                                Share.shareFiles([imageFile.path], text: 'My Image Collage Pdf File');
                              })
                        ],
                      ),
                      title: Text('My Collages ${index + 1}'),
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
}
