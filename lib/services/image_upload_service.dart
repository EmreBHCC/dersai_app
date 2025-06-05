// lib/services/image_upload_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/imgur-api.dart';
import '../models/image_result_model.dart';

class ImageUploadService {
  static Future<ImageResultModel> uploadImageToImgur(File image) async {
    var request = http.MultipartRequest(
      Constants.post,
      Uri.parse(Constants.posturl),
    );
    request.headers["Authorization"] = Constants.clientID;
    var file = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(file);

    var response = await request.send();
    var result = await http.Response.fromStream(response);
    var decoded = jsonDecode(result.body);

    return ImageResultModel(
      imageId: decoded["data"]["id"],
      imageUrl: decoded["data"]["link"],
    );
  }

  static Future<DetectionResultModel> uploadImageFromUrl(
    String imageUrl,
  ) async {
    var url = Uri.parse("http://192.168.1.155:7000/detect-board");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image_url': imageUrl}),
    );

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      return DetectionResultModel(
        decodedImageUrl: decoded['image_url'],
        detections: decoded['detections'],
      );
    } else {
      throw Exception("Detection failed: ${response.body}");
    }
  }
}
