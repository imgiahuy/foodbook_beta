import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  final String cloudName = "dqcycbx5k";
  final String uploadPreset = "preset_1";

  Future<String> uploadImage(File imageFile) async {
    final dio = Dio();
    final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path),
      "upload_preset": uploadPreset,
    });

    final response = await dio.post(url, data: formData);

    if (response.statusCode == 200) {
      return response.data["secure_url"];
    } else {
      throw Exception("Failed to upload image: ${response.statusCode}");
    }
  }
}
