import 'package:ameen/ui/Screens/general_setting.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameen/services/user_service.dart';
import 'package:ameen/ui/Screens/profile_setting.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_user_profile.dart';
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
  FirebaseUser currentUser;
  UserProfile({Key key, @required this.currentUser}): super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  CollectionReference usersRef = Firestore.instance.collection(DatabaseTable.users);
  String userId;
  UserService get services => GetIt.I<UserService>();
  UserModel userModel;
  String errorMessage;
  Logger logger = Logger();
  bool _isLoading = false;

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "المنشورات",
    )
  ];

  @override
  void initState() {
    super.initState();
    userId = widget.currentUser.uid;
//    _fetchUserProfileData();
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cBackground,
      body: DefaultTabController(
        length: myTabs.length,
        child: InheritedUserProfile(
          userModel: userModel,
          child: (_isLoading)
              ? RefreshProgress()
              : NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      _sliverAppBar(),
                    ];
                  }, body: Container(),
//                  body:
//                  TabBarView(
//                    children: (_isLoading)
//                        ? RefreshProgress()
//                        : return Container(),
//                  ),
                ),
        ),
      ),
    );
  }

  // Get List Of Posts of User [Posts, Saved Posts]
//  List<Widget> _getListOfPostsOfUser() {
//    int totalOfPosts = userModel.userPosts.length;
//
//    return [
//      (totalOfPosts >= 1)
//          ? AnimatedList(
//              initialItemCount: totalOfPosts,
//              itemBuilder: (BuildContext context, int index, Animation anim) {
//                return SizeTransition(
//                  axis: Axis.vertical,
//                  sizeFactor: anim,
//                  child: PostWidget(postModel: userModel.userPosts[index]),
//                );
//              })
//          : Center(
//              child: Text(Texts.NotFoundPosts,
//                  style: TextStyle(
//                      fontSize: 20,
//                      fontFamily: 'Dubai',
//                      color: AppColors.cBlack)))
//    ];
//  }

  void _fetchUserProfileData() async {
    setState(() {
      _isLoading = true;
    });
    await services.getUserProfile().then((response) => {
          if (response.error)
            {errorMessage = response.errorMessage ?? 'حدث خلل ما'}
          else
            {userModel = response.data}
        });
    setState(() {
      _isLoading = false;
    });
  }

  Widget _sliverAppBar() {
    return InheritedUserProfile(
      userModel: userModel,
      child: SliverAppBar(
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
          tabs: myTabs,
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: ProfileAppBar(currentUser: widget.currentUser),
          collapseMode: CollapseMode.pin,
          centerTitle: true,
        ),
        title: Text(
          "الصفحة الشخصية",
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: ImageIcon(
                AssetImage(AppIcons.settings),
                size: 20,
                color: Colors.grey[800],
              ),
              onPressed: () {
                pushPage(context, GeneralSettingPage(currentUser: widget.currentUser));
              }),
        ],
      ),
    );
  }
}
