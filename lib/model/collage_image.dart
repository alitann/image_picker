class CollageImage extends CImage {
  CollageImage(super.path);
}

abstract class CImage {
  final String path;

  CImage(this.path);
}
