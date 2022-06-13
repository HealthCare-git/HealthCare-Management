import 'package:get/get.dart';

class AddVideoController extends GetxController{
  var typeOfVideo = 'gym'.obs;
  void change(typeChange) => typeOfVideo.value = typeChange;
  var addVideoData = AddVideoData(image: 'https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png').obs;
  updateImage(String imgUrl){
    addVideoData.update((val) {
      val!.image = imgUrl;
    });
  }

}

class AddVideoData{
  String image;
  AddVideoData({required this.image});
}

