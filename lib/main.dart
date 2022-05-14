import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/bloc/bloc/bottom_navigation_bloc.dart';
import 'package:image_collage/view/main_view.dart';

void main() => runApp(const ImageCollageApp());

class ImageCollageApp extends StatelessWidget {
  const ImageCollageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavigationBloc>(
            create: (BuildContext context) => BottomNavigationBloc(),
          ),
          // BlocProvider<ImagePickerBloc>(
          //   create: (BuildContext context) => ImagePickerBloc(),
          // ),
        ],
        child: const MainView(),
      ),

      // MultiBlocProvider(providers: [
      //   BlocProvider(
      //     create: (context) => BottomNavigationBloc(),
      //     child: const MainView(),
      //   ),
      //   BlocProvider(
      //     create: (context) => ImagePickerBloc(),
      //     child: const MainView(),
      //   ),
      // ], child: child),
    );
  }
}
