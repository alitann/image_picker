import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_collage/bloc/bloc/image_picker_bloc.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  double imageQuality = 100.0;
  ImagePickerBloc? imagePickerBloc;

  @override
  void initState() {
    super.initState();
    imagePickerBloc = BlocProvider.of<ImagePickerBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.title.toString()),
        Slider(
            label: (imageQuality ~/ 1).toString(),
            value: imageQuality,
            divisions: 10,
            max: 100.0,
            min: 0.0,
            onChanged: (val) {
              setState(() {
                imageQuality = val;
                imagePickerBloc?.add(ImagePickerSetQualityEvent((imageQuality ~/ 1)));
              });
            }),
      ],
    );
  }
}
