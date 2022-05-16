part of 'collage_list_bloc.dart';

abstract class CollageListEvent extends Equatable {
  const CollageListEvent();

  @override
  List<Object> get props => [];
}

class CollageListLoadEvent extends CollageListEvent {}

class CollageListDeleteEvent extends CollageListEvent {
  final File file;

  const CollageListDeleteEvent(this.file);
}
