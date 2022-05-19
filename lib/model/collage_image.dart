class CollageImage extends CImage {
  CollageImage({required super.path, this.orderNumber = -1});
  final int? orderNumber;
}

abstract class CImage {
  String path;

  CImage({required this.path});
}
