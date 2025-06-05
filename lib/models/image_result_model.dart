// image_result_model.dart
class ImageResultModel {
  final String imageId;
  final String imageUrl;

  ImageResultModel({required this.imageId, required this.imageUrl});
}

// detection_result_model.dart
class DetectionResultModel {
  final String decodedImageUrl;
  final List<dynamic> detections;

  DetectionResultModel({
    required this.decodedImageUrl,
    required this.detections,
  });
}
