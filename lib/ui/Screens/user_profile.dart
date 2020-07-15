import 'package:ameen/ui/Screens/general_setting.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:ameencommon/common_widget/shimmer_widget.dart';
import 'package:ameencommon/localizations.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/services/user_service.dart';
import 'package:ameen/ui/widgets/profile_app_bar.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';

class UserProfile extends StatefulWidget {
  String profileId;
  FirebaseUser currentUser;
  UserProfile({Key key, @required this.profileId, @required this.currentUser})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin<UserProfile> {
  CollectionReference usersRef =
      Firestore.instance.collection(DatabaseTable.users);
  CollectionReference postsRef =
      Firestore.instance.collection(DatabaseTable.posts);
  List<PostWidget> posts = [];

  String userId;
  UserService get services => GetIt.I<UserService>();
  UserModel userModel;
  String errorMessage;
  Logger logger = Logger();
  bool _isLoading = false;

  final List<Tab> myTabs = <Tab>[
    Tab(
      text:'المنشورات',
    )
  ];

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
    _fetchUserPosts();
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
  }

  _fetchUserPosts() async {
    setState(() => _isLoading = true);
    QuerySnapshot snapshot = await postsRef
        .document(widget.profileId)
        .collection('userPosts')
        .orderBy('created_at', descending: true)
        .getDocuments();

    setState(() {
      posts = snapshot.documents
          .map((doc) => PostWidget.fromDocument(doc))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.cBackground,
      body: DefaultTabController(
        length: 1,
        child: (_isLoading)
            ? RefreshProgress()
            : RefreshIndicator(
            color:  AppColors.cGreen,
            backgroundColor: Colors.white,
            onRefresh: () async => _fetchUserPosts(),
              child: NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      _sliverAppBar(),
                    ];
                  },
                  body: (_isLoading)
                      ? ShimmerWidget()
                      : (posts.length >= 1)
                          ? SingleChildScrollView(
                              child: Container(child: Column(children: posts)))
                          : Center(
                              child: Text(AppTexts.NotFoundPosts,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Dubai',
                                      color: AppColors.cBlack)))),
            ),
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      elevation: 1.0,
      centerTitle: true,
      expandedHeight: 290.0,
      bottom: TabBar(
        labelColor: AppColors.green[800],
        indicatorColor: AppColors.green[800],
        unselectedLabelColor: Colors.grey[400],
        labelStyle: TextStyle(
          fontSize: 13.0,
          fontFamily: 'Dubai',
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            text: AppLocalizations.of(context).posts,
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: ProfileAppBar(
          profileId: widget.profileId,
          currentUser: widget.currentUser,
        ),
        collapseMode: CollapseMode.pin,
        centerTitle: true,
      ),
      title: Text(
        AppLocalizations.of(context).profile,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Dubai',
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        Visibility(
          // Check if the current user is the owner of profile?
          visible: widget.currentUser.uid == widget.profileId ? true : false,
          child: IconButton(
              icon: ImageIcon(
                AssetImage(AppImages.settings),
                size: 20,
                color: Colors.grey[800],
              ),
              onPressed: () {
                pushPage(
                    context, GeneralSettingPage(currentUser: widget.currentUser));
              }),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
