import 'package:flutter/material.dart';
import 'package:healthcare_management/utils/texts.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text1(text: "Event Page", color: Colors.black, size: 17),
        //leading: CustomBackButton(color: Colors.black,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://assets-in.bmscdn.com/promotions/cms/creatives/1659617323365_sony_web.jpg"),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Text1(text: "Events", color: Colors.black, size: 18),
                  const SizedBox(height: 10,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:List.generate(5, (index) => Padding(
                        padding: EdgeInsets.all(10),
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.orangeAccent.shade200,
                                  image: const DecorationImage(
                                    image: NetworkImage("https://assets-in.bmscdn.com/discovery-catalog/events/tr:w-400,h-600,bg-CCCCCC:w-400.0,h-660.0,cm-pad_resize,bg-000000,fo-top:oi-discovery-catalog@@icons@@like_202006280402.png,ox-24,oy-617,ow-29:ote-NDhrIGxpa2Vz,ots-29,otc-FFFFFF,oy-612,ox-70:q-80/et00098735-pluvvdrupz-portrait.jpg"),
                                    fit: BoxFit.cover,
                                  )
                              ),
                              width: 230,
                              height: 250,
                              padding: EdgeInsets.all(10),
                            ),
                            Text1(text: "10-Aug-2022", color: Colors.black, size: 15),
                            Text1(text: "10:00 AM ", color: Colors.black, size: 13),
                          ],
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image:const DecorationImage(
                            image: NetworkImage("https://www.edrawsoft.com/templates/images/horizontal-discount-banner.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text1(text: "Upcoming Events..", color: Colors.black, size: 18),
                  const SizedBox(height: 10,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:List.generate(5, (index) => Padding(
                        padding: EdgeInsets.all(10),
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.orangeAccent.shade200,
                                  image: const DecorationImage(
                                    image: NetworkImage("https://i.pinimg.com/736x/6e/43/bf/6e43bf1df20f7ffa075d10d732a34654.jpg"),
                                    fit: BoxFit.cover,
                                  )
                              ),
                              width: 230,
                              height: 250,
                              padding: EdgeInsets.all(10),
                            ),
                            Text1(text: "Diwali", color: Colors.black, size: 15),
                            Text1(text: "25-Oct-2022", color: Colors.black, size: 13),
                          ],
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),

    );
  }
}
