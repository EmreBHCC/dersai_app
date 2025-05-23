import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/imgur-api.dart';

class MyImageProvider extends ChangeNotifier {
  String _imagePath = '';
  final List<String> result = [];
  String imageUrl = "";
  bool isImageUrl = false;
  bool isLoading = false;
  RxString picture = "".obs;
  RxList idList = [].obs;
  String get imagePath => _imagePath;
  bool isResultNotGet = false;
  String resultImage = "";
  List<dynamic>? _detections = [];
  String? _decoded_url = "";
  List<dynamic>? get detectionsList => _detections;
  String? get decoded_url => _decoded_url;
  String apiUrl = "http://192.168.246.212:7000";
 
Future<void> uploadImageFromUrl(String imageUrl) async {
  print("Gönderilen imageUrl: $imageUrl");

  try {
    var url = Uri.parse('$apiUrl/detect-board');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image_url': '$imageUrl'}),
    );

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      _detections = decodedData['detections'];
      _decoded_url = decodedData['image_url'];

      notifyListeners(); // Notify listeners of state change
    } else {
      print('Failed to fetch image from URL: ${response.statusCode}+ ${response.body}');
    }
  } catch (e) {
    print('Error uploading image from URL: $e');
}
}

  Future<void> uploadImage(File image) async {
    try {
      setLoading(true);

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

      var data = decoded["data"];
      idList.add(data["id"]);
      imageUrl = data["link"];
 

      print("Yüklenen resmin URL'si: $imageUrl");
      notifyListeners();
      await uploadImageFromUrl(imageUrl);
      print("resim modele gönderildi");
    } catch (e) {
      print("Hata oluştu: $e");
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void setIsResultNotGet(bool value) {
    isResultNotGet = value;
    notifyListeners();
  }

  void setIsImageUrl(bool value) {
    isImageUrl = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
