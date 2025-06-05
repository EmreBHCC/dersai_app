class DetectionResultModel {
  final String decodedImageUrl;
  final List<dynamic> detections;

  DetectionResultModel({
    required this.decodedImageUrl,
    required this.detections,
  });

  factory DetectionResultModel.fromJson(Map<String, dynamic> json) {
    return DetectionResultModel(
      decodedImageUrl: json['image_url'] ?? '',
      detections: json['detections'] ?? [],
    );
  }
}
