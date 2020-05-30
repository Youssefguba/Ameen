import 'package:ameen/blocs/models/user_data.dart';
import 'package:ameen/services/user_service.dart';
import 'package:ameen/ui/widgets/inherited_widgets/inherited_user_profile.dart';
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
  UserModel userModel;
  UserService get services => GetIt.I<UserService>();

  bool _isLoading = false;
  String errorMessage;

  var logger = Logger();

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
        length: 2,
        child: InheritedUserProfile(
          userModel: userModel,
          child:(_isLoading) ? Center (
              child: RefreshProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(MyColors.cGreen),
              )
          ) : NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                _sliverAppBar(),
              ];
            },
            body: ListView(
              children: <Widget>[],
            ),
          ),
        ),
      ),
    );
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
          tabs: [
            Tab(
              text: "المنشورات",
            ),
            Tab(
              text: "الأدعية المحفوظة",
            ),
          ],
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
              AssetImage("assets/images/settings.png"),
              size: 20,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
