import 'package:flutter/material.dart';

class ListCollageView extends StatelessWidget {
  const ListCollageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collage List'),
      ),
      body: const Center(
        child: Text('View 2'),
      ),
    );
  }
}
