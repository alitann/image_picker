part of 'collage_list_bloc.dart';

abstract class CollageListState extends Equatable {
  const CollageListState();

  @override
  List<Object> get props => [];
}

class CollageListInitial extends CollageListState {}

class CollageListLoading extends CollageListState {}

class CollageListDeleted extends CollageListState {}

class CollageListLoaded extends CollageListState {
  final List<File> imagePdfFiles;
  const CollageListLoaded({required this.imagePdfFiles});
}

class CollageListError extends CollageListState {
  final String errorMessage;
  const CollageListError(this.errorMessage);
}
