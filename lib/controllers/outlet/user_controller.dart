import 'package:audioplayers/audioplayers.dart';
import 'package:get/state_manager.dart';
import 'package:onehubrestro/models/user.dart';

class UserController extends GetxController{
  var outlet = User().obs;

  var token = ''.obs;

  Map<int, AudioPlayer> sounds = Map();

  void updateOutlet(User data){
    outlet.value = data;
  }

  void updateToken(String value){
    token.value = value;
  }
}