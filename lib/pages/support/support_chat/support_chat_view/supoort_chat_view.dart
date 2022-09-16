import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_management/utils/constants.dart';
import 'package:healthcare_management/utils/texts.dart';
import 'package:intl/intl.dart';

class SupportChat extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    String chatRoomId(String user1, String user2) {
      if (user1.hashCode <= user2.hashCode) {
        return "$user1$user2";
      } else {
        return "$user2$user1";
      }
    }
    TextEditingController txt1 = TextEditingController();
    String? message;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ChatDataController chatDataController = Get.put(ChatDataController());
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.all(20.0),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('supportChatRoom').orderBy("time").snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.data ==null){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      List<Widget> chatList=[];
                        ListTile chatlistTile(Timestamp timestamp,String id,String token){
                          DateTime time = timestamp.toDate();
                          String _dateformat=DateFormat.yMMMMEEEEd().format(time);
                          String _timeformat = DateFormat.Hm().format(time);
                          return ListTile(
                            onTap: (){
                           chatDataController.updateId(id,token);
                           },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$id',style: TextStyle(fontSize: 12),),
                                //Text('$mobile',style: TextStyle(fontSize: 12),),
                              ],
                            ),
                            subtitle: Text('Time: $_timeformat  $_dateformat' ,style: TextStyle(fontSize: 10),),
                          );
                        }
                      for(var i in snapshot.data!.docs.reversed){
                        var wids = chatlistTile( i.get('time'),i.get('sent_by'),i.get('token'));
                        chatList.add(wids);
                      }
                      return ListView(
                       physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: chatList
                      );
                    }
                  )

                ],
              ),
            )),
         Expanded(
            flex: 2,
            child: Container(
              height: height,
              color: Colors.grey.shade200,
              //width: width*0.8,
              child: Stack(
                children: [
                   Padding(
           padding: EdgeInsets.only(bottom:height*0.1),
           child: Row(
             children: [
              Obx((){
                print(chatDataController.chatData.value.id);
                String roomId =
                chatRoomId("${chatDataController.chatData.value.id}","HCID2gNZBEgsyHOwfNYakwfHCROVP0z1");
                print(roomId);

                return  Expanded(
                 flex: 1,
                 child: SingleChildScrollView(
                   reverse: true,
                   physics: ScrollPhysics(),
                   child: StreamBuilder<QuerySnapshot>(
                     stream: FirebaseFirestore.instance.collection('supportChatRoom/$roomId/chats').orderBy("time").snapshots(),
                     builder: (context, snapshot) {
                       print(snapshot.data?.size);

                       if(snapshot.data==null){
                         return Center(child: Text1(text: "Start your queries we will join you Shortly", color: Colors.black54, size: 20));
                       }

                       if(snapshot.connectionState==ConnectionState.waiting){
                         return Center(child: CircularProgressIndicator(),);
                       }
                                
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.data==null){
                        return Center(child: Text1(text: "Start your queries we will join you Shortly", color: Colors.black54, size: 20));
                      }
                   
                                
                      List<Widget> messages = [];
                      final messegess = snapshot.data!.docs.reversed;
                      //print(messegess);
                      for(var i in messegess){
                        var content = i.get('message');
                        //var image = i.get('image');
                        var support = i.get('support');
                        var timestamp = i.get('time');
                       
                        var wids = supportTeamMessage(width, content, timestamp,support);
                        messages.add(wids);
                      }
                      //print(messages);
                      return ListView(
                         shrinkWrap: true,
                         reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: messages,
                        
                      );
                    }
                                
                    else{
                      return const SizedBox(
                          height: 50,width: 50,
                          child: Center(child:CircularProgressIndicator(color: Color(themeColor),),));
                    }
                     }
                   ),
                 ),
               );
             
              })
             
             ],
           ),
         ),


                  Align(
           alignment: Alignment.bottomCenter,
           child: Padding(
             padding:  EdgeInsets.only(left:10,bottom: 8,right: 15),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Row(
                   children: [
                     Expanded(
                       flex:5,
                       child: Container(
                         padding: EdgeInsets.all(5),
                         alignment: Alignment.center,
                        // height: height*0.05,
                        // width: width*0.85,
                         decoration: BoxDecoration(
                           color: const Color(themeColor2),
                           borderRadius: BorderRadius.circular(10)
                         ),
                         child: TextFormField(
                           maxLines: null,
                           controller: txt1,
                           onChanged: (value){
                             message = value;
                           },
                           style: GoogleFonts.aBeeZee(fontSize: 12,color: Colors.black54),
                           decoration: InputDecoration(
                             hintText: 'Send Message',
                             border: InputBorder.none,
                              hintStyle: GoogleFonts.aBeeZee(fontSize: 12,color: Colors.black54)
                           ),
                         ),
                       ),
                     ),

                     Expanded(
                       flex: 1,
                       child:CircleAvatar(
                           backgroundColor: const Color(themeColor),
                           child: IconButton(onPressed: (){
                             String roomId =
                             chatRoomId("${chatDataController.chatData.value.id}","HCID2gNZBEgsyHOwfNYakwfHCROVP0z1");

                            //  FirebaseFirestore.instance.doc('users_folder/folder/client_users/${chatDataController.chatData.value.id}/notification/haahcasb').set({
                            //         'route' : '/supportchat',
                            //          'sender' : 'New message from support chat',
                            //          'content' : '$message',
                            //          'token' : '${chatDataController.chatData.value.token}',
                            //          'image' : 'https://firebasestorage.googleapis.com/v0/b/swastik13-8242d.appspot.com/o/NewAppFiles%2Fcommonfiles%2Fcustomer-service.png?alt=media&token=78d7e4c7-435a-4996-8180-8962b599fdbe',
                            //   });
                             FirebaseFirestore.instance.collection('supportChatRoom/$roomId/chats').add({
                               'name':'Support Team',
                               'image':'https://firebasestorage.googleapis.com/v0/b/swastik13-8242d.appspot.com/o/NewAppFiles%2Fcommonfiles%2Fcustomer-service.png?alt=media&token=78d7e4c7-435a-4996-8180-8962b599fdbe',
                               'time':FieldValue.serverTimestamp(),
                               'message':message,
                              "sendby":"HCID2gNZBEgsyHOwfNYakwfHCROVP0z1",
                               'support':true,
                              "type":"text",
                             });
                            //  FirebaseFirestore.instance.collection('users_folder/folder/client_users/${chatDataController.chatData.value.id}/supportchat').add({
                            //    'name':"Support Chat",
                            //    'image':'https://firebasestorage.googleapis.com/v0/b/swastik13-8242d.appspot.com/o/NewAppFiles%2Fcommonfiles%2Fcustomer-service.png?alt=media&token=78d7e4c7-435a-4996-8180-8962b599fdbe',
                            //    'timestamp':FieldValue.serverTimestamp(),
                            //    'content':message,
                            //    'support':true,
                            //  });
                             txt1.clear();
                           }, icon: Icon(Icons.send_outlined,color: Colors.greenAccent,)))
                     )
                   ],
                 ),
               ],
             ),
           ),
         )
                ],
              )
              
              
              ))
       ],
   ),
     ),
   );
  }
 Padding supportTeamMessage(double width,String content,Timestamp timestamp,bool support) {
    //print("content is:"+content);
    DateTime messegaetime = timestamp.toDate();
    String _dateformat=DateFormat.yMMMMEEEEd().format(messegaetime);
    String _timeformat=DateFormat.jm().format(messegaetime);
    if(support==false){
      return  Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           Container(
                             padding: EdgeInsets.all(10),
                             width: width*0.45,
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: Text1(text: "$content", size: 12,color: Colors.black54,),
                           ),
                           SizedBox(width: 5,),
                           // Container(
                           //   height:35,width:35,
                           //   decoration: BoxDecoration(
                           //       shape: BoxShape.circle,
                           //       image: DecorationImage(
                           //           image: NetworkImage('$image'),
                           //           fit: BoxFit.fill
                           //       )
                           //   ),
                           // ),
                         ],
                       ),
                       SizedBox(height:5),
                       Padding(
                         padding: EdgeInsets.only(right: width*0.1),
                         child: Text1(text: "$_timeformat "  "$_dateformat", size: 11,color: Colors.black54,),
                       )
                     ],
                   ),
                 );
    }
    return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //   height:35,width:35,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //       image: NetworkImage('$image'),
                    //       fit: BoxFit.fill
                    //     )
                    //   ),
                    // ),
                    SizedBox(width: 5,),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: width*0.45,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text1(text: "$content", size: 12,color: Colors.white,),
                    )
                  ],
                ),
                SizedBox(height:5),
                Padding(
                  padding: EdgeInsets.only(left: width*0.1),
                  child: Text1(text: "$_timeformat "  "$_dateformat", size: 11,color: Colors.black54,),
                )
              ],
            ),
          );
  }
}

class ChatDataController extends GetxController{
  var chatData = ChatData().obs;

  updateId(String id,String token){
    chatData.update((val) {
      val!.id = id;
      val.token = token;
    });
    
  }
}
class ChatData{
  String? id = 'NOx6VzT1aoNv7PkE86ECHHkmH5U2';
  String? token;
  ChatData({this.id,this.token});
}
