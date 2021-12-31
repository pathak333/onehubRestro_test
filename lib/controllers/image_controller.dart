
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/upload_image_response.dart';
import 'package:onehubrestro/repository/dio_initializer.dart';
import 'package:onehubrestro/utilities/dialog_helper.dart';

class ImageController {
  final String uploadUrl = 'https://bulbandkey.com/gateway/addphoto';
  ImagePicker imagePicker = ImagePicker();

  var _dio = DioInitializer.initializeDio();

  var errorMessage = '';

  Future<XFile> choose(String type) async {
    return await imagePicker.pickImage(
        source: (type == 'camera') ? ImageSource.camera : ImageSource.gallery);
  }

  Future<String> upload(XFile file) async {
    if (file == null) return null;
    String fileName = file.path.split("/").last;

    var body = {
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "storage_url": "image",
      "filename": fileName
    };

    try {
      DialogHelper.showLoader();
      dio.FormData formData = new dio.FormData.fromMap(body);
      dio.Response response = await _dio.post(uploadUrl, data: formData);
      UploadImageResponse imageResponse =
          uploadImageResponseFromJson(response.data);
      if (imageResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        DialogHelper.hideLoader();
        return (imageResponse.photo as Photo).photo;
      } else {
        handleError(imageResponse.photo);
      }
      DialogHelper.hideLoader();
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> uploadImage(String type, var size) async {
    XFile file;

    ImageController imageController = ImageController();
    file = await imageController.choose(type);
    if (file != null) {
      return await imageController.upload(file);
    } else {
      return "not selected";
    }
  }

  void handleError(ErrorData data) {
    errorMessage = data.result.error;
  }
}
