import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/application_constants.dart';
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
    final bottomNavigationBloc = context.read<BottomNavigationBloc>();
    final List<Widget> tabBarViewList = [const CreateCollageView(), const ListCollageView()];

    return DefaultTabController(
      length: tabBarViewList.length,
      child: BlocBuilder<BottomNavigationBloc, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: tabBarViewList[bottomNavigationBloc.state],
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
        BottomNavigationBarItem(icon: Icon(Icons.add_to_photos_outlined), label: ApplicationConstants.create),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: ApplicationConstants.myFiles),
      ],
    );
  }
}
