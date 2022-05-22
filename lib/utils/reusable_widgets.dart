
import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management/utils/responsive.dart';
import 'package:healthcare_management/utils/texts.dart';

import '../controllers/authController.dart';
import 'constants.dart';

class ImageTextButton extends StatelessWidget {
  const ImageTextButton({
    required this.image,
    required this.name,
    Key? key,
  }) : super(key: key);

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height < 800?8:10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: MediaQuery.of(context).size.height < 700?10:15,
                    child: Image.asset(image)),
              ),
              Text(name,style: const TextStyle(color: Colors.black),)
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormsEdited extends StatelessWidget {
  const TextFormsEdited({
    required this.text,
    required this.labelText,
    Key? key,
  }) : super(key: key);
  final String text;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          const SizedBox(height:10),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey,width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(10),
                )
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: labelText,
                suffixIcon: text!="Email"?GestureDetector(child: const Icon(Icons.remove_red_eye,color: Color(themeColor),),):null,
                prefixIcon: Container(
                  width: 10,
                  child: text=="Email"?const Icon(Icons.email_outlined):Icon(Icons.password),
                ),
                hintStyle: TextStyle(color:Colors.black54,fontSize: ResponsiveWidget.isLargeScreen(context)?20:ResponsiveWidget.isMediumScreen(context)?15:0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomImageUploader extends StatefulWidget {
  final networkImageUrl;
  final path;
  final imageHeight;
  final imageWidth;
  final Function(String string) onPressed;

  const CustomImageUploader(
      {Key? key,
        this.networkImageUrl =
        "https://lanecdr.org/wp-content/uploads/2019/08/placeholder.png",
        required this.path,
        required this.onPressed,
        this.imageHeight = 100,
        this.imageWidth = 100})
      : super(key: key);

  @override
  _CustomImageUploaderState createState() => _CustomImageUploaderState();
}
class _CustomImageUploaderState extends State<CustomImageUploader> {
  String? imgUrl;

  uploadToStorage() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Alert"),
          content:
          Text("Are you sure that you want to update this picture?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  FileUploadInputElement input = FileUploadInputElement()
                    ..accept = 'image/*';
                  FirebaseStorage fs = FirebaseStorage.instance;
                  input.click();
                  input.onChange.listen((event) {
                    Get.bottomSheet(const Center(
                      child: CircularProgressIndicator(color: Colors.white,),
                    ));
                    final file = input.files!.first;
                    final reader = FileReader();
                    reader.readAsDataUrl(file);
                    reader.onLoadEnd.listen((event) async {
                      var snapshot =
                      await fs.ref().child(widget.path).putBlob(file);
                      String downloadUrl =
                      await snapshot.ref.getDownloadURL();
                      setState(() {
                        imgUrl = downloadUrl;
                        widget.onPressed(downloadUrl);
                      });
                      Get.back();

                    });
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Continue")),
          ],
        ));
  }

//--
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          uploadToStorage();
        },
        child: Container(
          height: widget.imageHeight,
          width: widget.imageWidth,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.blue,
                  width: 1,
                  style: BorderStyle.solid),
              image: DecorationImage(
                  image: NetworkImage(
                    imgUrl == null
                        ? widget.networkImageUrl == null
                        ? "https://lanecdr.org/wp-content/uploads/2019/08/placeholder.png"
                        : widget.networkImageUrl
                        : imgUrl,
                  ),
                  fit: BoxFit.contain)),
        ));
  }
}


class FunctionCards extends StatelessWidget {
  const FunctionCards({
    Key? key,required this.text,required this.iconData,this.ontap
  }) : super(key: key);
  final ontap;
  final String text;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //hoverColor: Colors.white38,
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.all(10),
        //margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        height: ResponsiveWidget.isSmallScreen(context)?70:150,
        width: ResponsiveWidget.isSmallScreen(context)?70:150,
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData,size: ResponsiveWidget.isSmallScreen(context)?20:40,),
            SizedBox(height: 5,),
            Text(text,style: ResponsiveWidget.isSmallScreen(context)?context.theme.textTheme.bodySmall:context.theme.textTheme.bodyMedium,)
          ],
        ),
      ),
    );
  }
}




class TextFormsEdited2 extends StatelessWidget {
   TextFormsEdited2({
    required this.text,
    required this.obsecure,
    required this.labelText,
    required this.con,
     //this.needValidator=false,
    Key? key,
  }) : super(key: key);
  final String text;
  final String labelText;
  bool obsecure=false;
  final TextEditingController con;
  //bool needValidator;


  @override
  Widget build(BuildContext context) {

    String? validatorEmail(String value){
      if (AuthController.authInstance.firebaseUser.value == null){
        if (value.isEmpty && !(value.contains("@"))) {
          return "Enter a valid Email";
        }
      }
      return null;
    }

    String? validatePassword(String value) {
      //Added the regular expression which contains all the possible values for the condition of password
      if (AuthController.authInstance.firebaseUser.value == null){
        if ((value.length < 8)) {
          return 'Please enter password of 8 character';
        }
        if (value.isEmpty) {
          return 'Please enter password';
        }
        if ((!value.contains(RegExp(r"[a-z]"))) ||
            (!value.contains(RegExp(r"[A-Z]"))) ||
            (!value.contains(RegExp(r"[0-9]"))) ||
            (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))) {
          return "Please enter a valid password";
        }
      }
      return null;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          const SizedBox(height:10),
          TextFormField(
            obscureText: obsecure,
            controller: con,
            keyboardType: text=="Email"?TextInputType.emailAddress:text=="Password"?TextInputType.visiblePassword:TextInputType.text,
            decoration: InputDecoration(

              //errorText: text=="Email"?validatorEmail(con.text):text=="Password"?validatePassword(con.text):null,
              hintText: labelText,
              errorText: text=="Password"?validatePassword(text.trim()):text=="Email"?validatorEmail(text.trim()):null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              suffixIcon: text=="Password"?GestureDetector(
                onTap: (){
                  obsecure==true?obsecure=false :null;
                },
                child: const Icon(Icons.remove_red_eye,color: Color(themeColor),),):null,
              prefixIcon: Container(
                width: 10,
                child: text=="Email"?const Icon(Icons.email_outlined):text=="Name"?const Icon(Icons.text_fields):const Icon(Icons.password),
              ),
              hintStyle: TextStyle(color:Colors.black54,fontSize: ResponsiveWidget.isLargeScreen(context)?20:ResponsiveWidget.isMediumScreen(context)?15:0),
            ),
          ),
        ],
      ),
    );
  }
}


class ShowImage extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ShowImage({required this.imageUrl,required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Row(
          children: [
            Text2(weigth: true, size: 0.02, text: name, color: Colors.black),
          ],
        ),
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}


class ContainerButton extends StatelessWidget {
   ContainerButton({
    required this.text,
    required this.padding,
    required this.page,
    Key? key,
  }) : super(key: key);
  final String text;
  var  padding;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Get.toNamed("$page");
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF0C9869),
          ),
          child: Padding(
            padding:  EdgeInsets.all(padding),
            child: Center(
              child: Text(text,style: GoogleFonts.saira(
                  fontSize: MediaQuery.of(context).size.height < 800?15:20,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IconTextForm extends StatelessWidget {
  const IconTextForm({
    required this.iconName,
    required this.name,
    required this.max,
    required this.min,
    required this.controller,
    //required this.initial,
    Key? key,
  }) : super(key: key);
  final Icon iconName;
  final String name;
  final int max;
  final int min;
  final TextEditingController controller;
 //final initial ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        //initialValue: initial,
        controller: controller,
        maxLines: max,
        minLines: min,
        decoration:  InputDecoration(

          icon: iconName,
          hoverColor:Color(themeColor) ,
          label: Text("$name",style: TextStyle(color: Color(themeColor)),),
        ),
      ),
    );
  }
}


Container redButton(String text) {
  return Container(
    margin: EdgeInsets.all(20),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 2.0)),
    child: Text(text),
  );
}


class MenuBarTile extends StatelessWidget{
  const MenuBarTile({Key? key,required this.tab, required this.selectedTab, this.onTap,required this.iconData,required this.titleText}) : super(key: key);
  final String selectedTab;
  final onTap;
  final IconData iconData;
  final String titleText;
  final String tab;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: tab == selectedTab,
      textColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
      selectedColor: Get.isDarkMode ? Colors.white : Colors.black,
      onTap: onTap,
      iconColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
      leading: Icon(
        iconData,
      ),
      title: ResponsiveWidget.isLargeScreen(context) ? Text(titleText) : null,
    );
  }

}


class EventCards extends StatelessWidget {
  const EventCards({
    Key? key,required this.text,required this.iconData,this.ontap, required this.remove,this.deleteOntap
  }) : super(key: key);
  final ontap;
  final deleteOntap;
  final String text;
  final String iconData;
  final bool remove;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //hoverColor: Colors.white38,
      onTap: remove?deleteOntap:ontap,
      child: Container(
        margin: EdgeInsets.all(10),
        //margin: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        height: ResponsiveWidget.isSmallScreen(context)?70:150,
        width: ResponsiveWidget.isSmallScreen(context)?70:150,
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerRight,
              height:  ResponsiveWidget.isSmallScreen(context)?40:70,
              width:  ResponsiveWidget.isSmallScreen(context)?60:100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(iconData),fit: BoxFit.cover)
              ),
              child: remove?Icon(Icons.delete_forever_outlined):null,
            ),
            const SizedBox(height: 5,),
            Text(text,style: TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context)?8:14))
          ],
        ),
      ),
    );
  }
}





