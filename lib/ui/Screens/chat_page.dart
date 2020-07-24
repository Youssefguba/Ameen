import 'dart:io';

import 'package:ameen/ui/Screens/ways_page.dart';
import 'package:ameen/ui/widgets/full_photo.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
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
  final String peerUsername;

  const Chat({Key key, this.peerId, this.peerAvatar, this.peerUsername})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          style:
              TextStyle(color: AppColors.cGreen, fontWeight: FontWeight.bold),
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
  final String peerUsername;

  ChatScreen({Key key, this.peerId, this.peerAvatar, this.peerUsername})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, peerUsername: peerUsername);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerUsername});
  String peerId;
  UserModel _peerUser, _currentUser;
  String peerAvatar;
  String peerUsername;
  String id;
  String groupChatId;
  String imageUrl;
  String _lastMsg;
  String _lastMsgTime;
  String data;
  String timeOfMessage;
  SharedPreferences prefs;
  File imageFile;
  bool isLoading;
  bool isShowSticker;

  ImagePicker picker = ImagePicker();
  File _imageSelected;

  dynamic listMessage;
  dynamic peerUserData, currentUserData;

  TextEditingController _textEditingController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getPeerUserData();
    _getCurrentUserData();
  }

  // Get peer user data
  _getPeerUserData() async {
    UserModel peerUser = await getUserData(peerId);
    setState(() {
      _peerUser = peerUser;
    });
  }

  // Get current user data
  _getCurrentUserData() async {
    UserModel cUser = await getUserData(currentUser.uid);
    setState(() {
      _currentUser = cUser;
    });
  }

  void onSendMessage(String content, int type) async {

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

      addPeerInMyChatsList();
      addMeInPeerChatsList();

      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      showToast(context, 'الرسالة فارغة', AppColors.cBlack);
    }
  }

  Future addPeerInMyChatsList() async {
    // Check if the peer is existed in chats list or not.
    DocumentSnapshot userChatsList = await DbRefs.chatsListRef
        .document(currentUser.uid)
        .collection(currentUser.uid)
        .document(peerId)
        .get();

    // Get Last message in chat
    DbRefs.messagesRef
        .document(currentUser.uid)
        .collection(peerId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((val) {
      Map<String, dynamic> documentData = val.documents.single.data;
      data = documentData['content'];
      timeOfMessage = documentData['timestamp'];
      _lastMsgTime = timeOfMessage;
      _lastMsg = data;
      return _lastMsg;
    });

    if (userChatsList.exists) {
      DbRefs.chatsListRef
          .document(currentUser.uid)
          .collection(currentUser.uid)
          .document(peerId)
          .updateData({'lastMessage': _lastMsg, 'timestamp': _lastMsgTime});
    } else {
      DbRefs.chatsListRef
          .document(currentUser.uid)
          .collection(currentUser.uid)
          .document(peerId)
          .setData({
        'username': _peerUser.username,
        'profilePicture': _peerUser.profilePicture,
        'lastMessage': _lastMsg,
        'peerId': peerId,
        'timestamp': _lastMsgTime
      });
    }
  }

  Future addMeInPeerChatsList() async {
    // Check if the peer is existed in chats list or not.
    DocumentSnapshot peerChatsList = await DbRefs.chatsListRef
        .document(peerId)
        .collection(peerId)
        .document(currentUser.uid)
        .get();

    // Get Last message in chat
    DbRefs.messagesRef
        .document(peerId)
        .collection(currentUser.uid)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((val) {
      Map<String, dynamic> documentData = val.documents.single.data;
      String data = documentData['content'];
      String timeOfMessage = documentData['timestamp'];
      _lastMsg = data;
      _lastMsgTime = timeOfMessage;
      return _lastMsg;
    });

    if (peerChatsList.exists) {
      DbRefs.chatsListRef
          .document(peerId)
          .collection(peerId)
          .document(currentUser.uid)
          .updateData({'lastMessage': _lastMsg, 'timestamp': _lastMsgTime});
    } else {
      DbRefs.chatsListRef
          .document(peerId)
          .collection(peerId)
          .document(currentUser.uid)
          .setData({
        'username': _currentUser.username,
        'profilePicture': _currentUser.profilePicture,
        'lastMessage': _lastMsg,
        'peerId': currentUser.uid,
        'timestamp': _lastMsgTime
      });
    }
  }

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
    StorageReference reference =
        FirebaseStorage.instance.ref().child('ChatsImage').child(fileName);
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

  Future getImageFromPhone() async {
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageSelected = File(pickedImage.path);
    });
    uploadPhoto(context, "Chats Image", _imageSelected).then((photoUrl) {
      setState(() {
        imageUrl = photoUrl;
      });
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    });
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
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
              // buildLoading()
            ],
          ),
        ),
      ),
    );
  }

  Widget appBarWidget() {
    return AppBar(
      centerTitle: true,
      title: Text(peerUsername ??= '',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontFamily: 'Dubai')),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 40,
            height: 20,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.cBackground,
              backgroundImage: peerAvatar == null
                  ? AssetImage(AppImages.AnonymousPerson)
                  : CachedNetworkImageProvider(peerAvatar),
            ),
          ),
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => popPage(context),
      ),
    );
  }

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
                  decoration: BoxDecoration(
                      color: AppColors.cGreen,
                      borderRadius: BorderRadius.circular(12.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )

              // Image
              : Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.cGreen),
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
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
              },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
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
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Dubai'),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : Container(
                        child: FlatButton(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.cGreen),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                    },
                          padding: EdgeInsets.all(0),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      )
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm', 'ar').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
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
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.cGreen)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
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
                onPressed: getImageFromPhone,
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
                  hintText: AppLocalizations.of(context).typeYourMessage,
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
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
}
