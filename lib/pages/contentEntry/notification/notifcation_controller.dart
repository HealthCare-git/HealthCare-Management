import 'package:get/get.dart';

class NotificationController extends GetxController {

  var app = 'healthcare'.obs;
  void change(typeChange) => app.value = typeChange;



}
