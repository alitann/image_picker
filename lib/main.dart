import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/bloc/image_collage_observer.dart';
import 'package:image_collage/repository/storage_repository.dart';
import 'package:image_collage/service/storage_service.dart';

import 'bloc/bloc/bottom_navigation_bloc.dart';
import 'bloc/bloc/collage_list_bloc.dart';
import 'bloc/bloc/image_picker_bloc.dart';
import 'view/main_view.dart';

void main() async {
  BlocOverrides.runZoned(
    () => runApp(const ImageCollageApp()),
    blocObserver: ImageCollageObserver(),
  );
}

class ImageCollageApp extends StatelessWidget {
  const ImageCollageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Collage',
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavigationBloc>(
            create: (BuildContext context) => BottomNavigationBloc(),
          ),
          BlocProvider<ImagePickerBloc>(
            create: (BuildContext context) => ImagePickerBloc(),
          ),
          BlocProvider<CollageListBloc>(
            create: (BuildContext context) =>
                CollageListBloc(StorageRepository(StorageService()))..add(CollageListLoadEvent()),
          ),
        ],
        child: const MainView(),
      ),
    );
  }
}
