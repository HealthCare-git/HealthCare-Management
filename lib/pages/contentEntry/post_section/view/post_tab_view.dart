import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management/pages/contentEntry/post_section/view/update_post.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/reusable_widgets.dart';
import '../../../../utils/texts.dart';
import 'add_post_view.dart';



class PostTab extends StatelessWidget {
  String tab = Get.parameters['tab']!;

  PostTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity,Get.height*0.15),
          child: Card(
            color:Colors.green.shade100.withOpacity(0.6),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text1(text: "Post Management", color: const Color(themeColor), size: 30),
            ),
          )
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green.shade100.withOpacity(0.6),
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.2),
                      child: Column(
                        children: [
                          MenuBarTile(
                            selectedTab: 'up',
                            iconData: LineIcons.fileUpload,
                            titleText: 'Update Post',
                            tab: tab,
                            onTap: () {
                              Get.toNamed(
                                  '/home/${AppStrings.CONTENT_ENTRY}/post/up');
                            },
                          ),
                          MenuBarTile(
                            selectedTab: 'an',
                            iconData: LineIcons.newspaper,
                            titleText: 'Add Post',
                            tab: tab,
                            onTap: () {
                              Get.toNamed(
                                  '/home/${AppStrings.CONTENT_ENTRY}/post/an');
                            },
                          ),
                          MenuBarTile(
                            selectedTab: 'rp',
                            iconData: LineIcons.recycle,
                            titleText: 'Remove Post',
                            tab: tab,
                            onTap: () {
                              Get.toNamed(
                                  '/home/${AppStrings.CONTENT_ENTRY}/post/rp');
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: 4,
                child: Container(
                    margin: EdgeInsets.only(top: Get.height * .1),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(
                                'inventory/post_folder/post')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<Widget> _eventCards = [];
                          snapshot.data!.docs.forEach((element) {
                            _eventCards.add(EventCards(
                            remove: tab=='rp'?true:false,                           
                            text: element['name'],
                            deleteOntap: (){
                              print("delete called");
                              FirebaseFirestore.instance.doc('inventory/post_folder/post/${element.id}').delete();
                            },
                            iconData:
                                element['image'],
                            ontap: () {
                              print("image is:${element["image"]}");
                              //AddUpcomingController addUpcomingController =Get.put(AddUpcomingController());

                              Get.bottomSheet(
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    height: Get.height*0.9,
                                    child: UpdatePost(
                                      eventId: element.id,
                                      image: element["image"],
                                      updateName: element['name'],
                                      updateRoute: element["route"],
                                    ),
                                  ),
                                  backgroundColor: context.theme.backgroundColor,
                                  isScrollControlled: true
                              );

                            },
                            ));
                          });
                          if (tab == 'up' || tab == 'rp') {
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(                              
                                direction: Axis.horizontal,
                                children: _eventCards,
                              ),
                            );
                          } else if (tab == 'an') {
                            return AddPostView();
                          }
                          return SizedBox();
                        })),
              ),
            ],
          )
        ],
      ),
    );
  }
}

