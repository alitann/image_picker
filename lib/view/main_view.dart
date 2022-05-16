import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/bottom_navigation_bloc.dart';

import 'create_collage_view.dart';
import 'list_collage_view.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarController();
  }
}

class TabBarController extends StatelessWidget {
  const TabBarController({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //read navigationBloc and set a variable
    final bottomNavigationBloc = context.read<BottomNavigationBloc>();

    return DefaultTabController(
      length: 2,
      child: BlocBuilder<BottomNavigationBloc, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: bottomNavigationBloc.state == 0 ? const CreateCollageView() : const ListCollageView(),
            bottomNavigationBar: _customNavigationBar(selectedIndex, bottomNavigationBloc),
          );
        },
      ),
    );
  }

  BottomNavigationBar _customNavigationBar(int selectedIndex, BottomNavigationBloc bottomNavigationBloc) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => bottomNavigationBloc.add(TabBarChangeEvent(index)),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add_to_photos_outlined), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'My Files'),
      ],
    );
  }
}
