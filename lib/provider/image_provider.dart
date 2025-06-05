// lib/providers/image_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/image_upload_service.dart';

class MyImageProvider extends ChangeNotifier {
  final List<String> result = [];
  RxString picture = "".obs;
  RxList idList = [].obs;

  String _imageUrl = "";
  bool _isImageUrl = false;
  bool _isLoading = false;
  bool _isResultNotGet = false;

  List<dynamic>? _detections = [];
  String? _decodedUrl;

  String get imageUrl => _imageUrl;
  bool get isImageUrl => _isImageUrl;
  bool get isLoading => _isLoading;
  bool get isResultNotGet => _isResultNotGet;
  List<dynamic>? get detectionsList => _detections;
  String? get decodedUrl => _decodedUrl;

  Future<void> uploadImage(File image) async {
    setLoading(true);
    try {
      final result = await ImageUploadService.uploadImageToImgur(image);
      _imageUrl = result.imageUrl;
      idList.add(result.imageId);

      final detectionResult = await ImageUploadService.uploadImageFromUrl(
        _imageUrl,
      );
      _detections = detectionResult.detections;
      _decodedUrl = detectionResult.decodedImageUrl;

      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    } finally {
      setLoading(false);
    }
  }

  void setIsResultNotGet(bool value) {
    _isResultNotGet = value;
    notifyListeners();
  }

  void setIsImageUrl(bool value) {
    _isImageUrl = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
