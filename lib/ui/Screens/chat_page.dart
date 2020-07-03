import 'dart:io';

import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/widgets/chat_widgets/received_message_widget.dart';
import 'package:ameen/ui/widgets/chat_widgets/sended_message_widget.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  const Chat({Key key, this.peerId, this.peerAvatar}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          style: TextStyle(color: AppColors.cGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, this.peerId, this.peerAvatar}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});  String peerId;

  String peerAvatar;
  String id;
  String groupChatId;
  String imageUrl;

  SharedPreferences prefs;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  var listMessage;

  TextEditingController _textEditingController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  var childList = <Widget>[];

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child('ChatsImage').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      showToast(context, 'This file is not an image', AppColors.cBlack);
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      _textEditingController.clear();

      // Add data to User Ref
      var userCollectionRef = DbRefs.messagesRef
          .document(currentUser.uid)
          .collection(peerId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      // Add data to Peer Ref
      var peerCollectionRef = DbRefs.messagesRef
          .document(peerId)
          .collection(currentUser.uid)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          userCollectionRef,
          {
            'idFrom': currentUser.uid,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );

        await transaction.set(
          peerCollectionRef,
          {
            'idFrom': currentUser.uid,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );

      });

//      Firestore.instance.runTransaction((transaction) async {
//        await transaction.set(
//          peerCollectionRef,
//          {
//            'idFrom': currentUser.uid,
//            'idTo': peerId,
//            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//            'content': content,
//            'type': type
//          },
//        );
//      });

      _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      showToast(context, 'Nothing to send', AppColors.cBlack);
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),

                  // Input content
                  buildInput(),
                ],
              ),

                 // Loading
//                 buildLoading()
                ],
              ),
          ),
        ),
    );
  }

  //  Widget buildLoading() {
//    return Positioned(
//      child: isLoading ?  Container(
//        child: Center(
//          child: CircularProgressIndicator(
//            valueColor: AlwaysStoppedAnimation<Color>(AppColors.cGreen),
//          ),
//        ),
//        color: Colors.white.withOpacity(0.8),
//      ) : Container(),
//    );
//  }
  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == currentUser.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.white, fontFamily: 'Dubai'),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: AppColors.cGreen, borderRadius: BorderRadius.circular(12.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )

          // Image
              : Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.cGreen),
                    ),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      AppImages.imageNotAvailable,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
//              onPressed: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
//              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
          // Sticker
//              : Container(
//            child: Image.asset(
//              'images/${document['content']}.gif',
//              width: 100.0,
//              height: 100.0,
//              fit: BoxFit.cover,
//            ),
//            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
//          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.cGreen),
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: peerAvatar,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.black, fontFamily: 'Dubai'),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.grey.shade500.withOpacity(0.2), borderRadius: BorderRadius.circular(12.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    :  Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>( AppColors.cGreen),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            AppImages.imageNotAvailable,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
//                    onPressed: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
//                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
//                    : Container(
//                  child: Image.asset(
//                    'images/${document['content']}.gif',
//                    width: 100.0,
//                    height: 100.0,
//                    fit: BoxFit.cover,
//                  ),
//                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
//                ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: peerId == ''
          ? Center(child: RefreshProgress())
          : StreamBuilder(
        stream: DbRefs.messagesRef
            .document(currentUser.uid)
            .collection(peerId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.cGreen)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: _scrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: AppColors.cGreen,
              ),
            ),
            color: Colors.white,
          ),
//          Material(
//            child: Container(
//              margin: EdgeInsets.symmetric(horizontal: 1.0),
//              child: IconButton(
//                icon: Icon(Icons.face),
//                onPressed: getSticker,
//                color: primaryColor,
//              ),
//            ),
//            color: Colors.white,
//          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: AppColors.cBlack, fontSize: 15.0),
                controller: _textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(_textEditingController.text, 0),
                color: AppColors.cGreen,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

}
