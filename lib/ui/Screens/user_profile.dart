import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/services/user_service.dart';
import 'package:ameen/ui/Screens/home.dart';
import 'package:ameen/ui/Screens/setting.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_user_profile.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:ameen/ui/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserService get services => GetIt.I<UserService>();

  final List<Tab> myTabs = <Tab>[
    // Posts of User
    Tab(
      text: "المنشورات",
    ),
    // Saved Posts
//    Tab(
//      text: "الأدعية المحفوظة",
//    ),

  ];
  UserModel userModel;
  String errorMessage;
  Logger logger = Logger();

  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _fetchUserProfileData();
  }

  _fetchUserProfileData() async {
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.cBackground,
      body: DefaultTabController(
        length: myTabs.length,
        child: InheritedUserProfile(
          userModel: userModel,
          child:(_isLoading) ? Center (
              child: RefreshProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(MyColors.cGreen),
              )
          )
              : NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                _sliverAppBar(),
              ];
            },
            body: TabBarView(
              children: (_isLoading) ? Center (
                  child: RefreshProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(MyColors.cGreen),
                  )
              )
                  : _getListOfPostsOfUser(),
            ),
          ),
        ),
      ),
    );
  }

  /// Get List Of Posts of User [Posts, Saved Posts]
  List<Widget> _getListOfPostsOfUser(){
    int totalOfPosts = userModel.userPosts.length;
    int totalOfSavedPosts = userModel.savedPosts.length;

   return [
     // Posts of User
     (totalOfPosts >= 1) ?  AnimatedList(
          initialItemCount: totalOfPosts,
          itemBuilder:
              (BuildContext context, int index, Animation anim) {
            return SizeTransition(
              axis: Axis.vertical,
              sizeFactor: anim,
              child: PostWidget(postModel: userModel.userPosts[index]),
            );
          }) : Center(child: Text(Texts.NotFoundPosts, style: TextStyle(fontSize: 20, fontFamily: 'Dubai', color: MyColors.cBlack))), ];

//     // Saved Posts Of User
//     (totalOfSavedPosts >= 1) ? AnimatedList(
//          initialItemCount: totalOfSavedPosts,
//          itemBuilder:
//              (BuildContext context, int index, Animation anim) {
//            return SizeTransition(
//              axis: Axis.vertical,
//              sizeFactor: anim,
//              child: PostWidget(postModel: userModel.savedPosts[index])
//            );
//          }) : Center(child: Text(Texts.NotFoundSavedPosts, style: TextStyle(fontSize: 20, fontFamily: 'Dubai', color: MyColors.cBlack))),
//    ];
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
          labelColor: MyColors.green[800],
          indicatorColor: MyColors.green[800],
          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(
            fontSize: 13.0,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.bold,
          ),
          tabs: myTabs,
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: ProfileAppBar(),
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
              AssetImage(MyIcons.settings),
              size: 20,
              color: Colors.grey[800],
            ), onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage()));
          }
          ),
        ],
      ),
    );
  }
}
