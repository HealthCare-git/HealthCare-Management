import 'package:get/get.dart';

class DepartmentController extends GetxController{
  var addUpcomingData = AddPostData(
    image: 'https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png',
  ).obs;
  updateImage(String imgUrl){
    addUpcomingData.update((val) {
      val!.image = imgUrl;
    });
  }
}

class AddPostData{
  String image;
  AddPostData({required this.image});
}
