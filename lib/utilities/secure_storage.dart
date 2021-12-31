import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStoreMixin{

  final flutterSecureStorage = Get.put(FlutterSecureStorage());

  void setSecureStore(String key, String data) async {
    await flutterSecureStorage.write(key: key, value: data);
  }

  void getSecureStore(String key, Function callback) async {
    await flutterSecureStorage.read(key: key).then(callback);
  }

  void removeSecureStore(String key) async {
    await flutterSecureStorage.delete(key: key);
  }

}