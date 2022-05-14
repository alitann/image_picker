part of 'bottom_navigation_bloc.dart';

@immutable
abstract class BottomNavigationEvent extends Equatable {}

class TabBarChangeEvent extends BottomNavigationEvent {
  final int selectedIndex;

  TabBarChangeEvent(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}
