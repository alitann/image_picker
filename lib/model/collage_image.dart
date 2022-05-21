class CollageImage extends CImage {
  CollageImage({required super.path});
}

abstract class CImage {
  String path;

  CImage({required this.path});
}
