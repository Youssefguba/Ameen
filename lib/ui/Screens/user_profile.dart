import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';


class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: myColors.cBackground,
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
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

  /*
  * This Widget is Represent the AppBar of User Profile Screen
  * Y.G
  * */
  Widget _sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      elevation: 1.0,
      centerTitle: true,
      expandedHeight: 290.0,
      bottom: TabBar(
        labelColor: myColors.green[800],
        indicatorColor: myColors.green[800],
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
    );
  }
}
