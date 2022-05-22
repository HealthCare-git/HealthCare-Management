import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management/pages/contentEntry/video_section/update_video.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import '../../../utils/reusable_widgets.dart';
import 'add_video.dart';



class VideoTab extends StatelessWidget {
  String tab = Get.parameters['tab']!;

  VideoTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.2),
                    child: Column(
                      children: [
                        MenuBarTile(
                          selectedTab: 'up',
                          iconData: LineIcons.fileUpload,
                          titleText: 'Update Video',
                          tab: tab,
                          onTap: () {
                            Get.toNamed(
                                '/home/${AppStrings.CONTENT_ENTRY}/video/up');
                          },
                        ),
                        MenuBarTile(
                          selectedTab: 'an',
                          iconData: LineIcons.newspaper,
                          titleText: 'Add Video',
                          tab: tab,
                          onTap: () {
                            Get.toNamed(
                                '/home/${AppStrings.CONTENT_ENTRY}/video/an');
                          },
                        ),
                        MenuBarTile(
                          selectedTab: 'rp',
                          iconData: LineIcons.recycle,
                          titleText: 'Remove Video',
                          tab: tab,
                          onTap: () {
                            Get.toNamed(
                                '/home/${AppStrings.CONTENT_ENTRY}/video/rp');
                          },
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 4,
                child: Container(
                    margin: EdgeInsets.only(top: Get.height * .1),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(
                            'inventory/all_videos/videos')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<Widget> _videoCards = [];
                          snapshot.data!.docs.forEach((element) {
                            _videoCards.add(EventCards(
                              remove: tab=='rp'?true:false,
                              text: element["live"]==false?"${element['video_name']} (${element.id})":"${element['video_name']} (${element.id}) (live)",
                              deleteOntap: (){
                                print("delete called");
                                FirebaseFirestore.instance.doc('inventory/all_videos/videos/${element.id}').delete();
                                element["live"]==true?
                                FirebaseFirestore.instance.doc('inventory/all_videos/videos/${element.id}').delete():null;
                              },
                              iconData:
                              element['video_thumbnail'],
                              ontap: () {
                                //print(element["image"]);
                                //AddUpcomingController addUpcomingController =Get.put(AddUpcomingController());

                                Get.bottomSheet(
                                    Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      height: Get.height*0.9,
                                      child: UpdateVideo(
                                        //eventId: element.id,
                                        live: "${element["live"]}",
                                        about: "${element["about"]}",
                                        title: element["tittle"],
                                        video_category: element["video_category"],
                                        video_thumbnail: element["video_thumbnail"],
                                        video_key: element["video_key"],
                                        video_id: element["video_id"],
                                        video_name: element["video_name"],
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
                                children: _videoCards,
                              ),
                            );
                          } else if (tab == 'an') {
                            return AddVideo();
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

