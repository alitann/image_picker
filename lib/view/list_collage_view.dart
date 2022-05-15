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
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.list),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [Icon(Icons.slideshow_outlined), SizedBox(width: 10), Icon(Icons.share_outlined)],
              ),
              title: Text("List item $index"),
              subtitle: const Text('Subtitle'),
            );
          }),
    );
  }
}
