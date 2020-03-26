import 'package:ameen/blocs/models/choice.dart';
import 'package:ameen/helpers/ui/app_color.dart';
import 'package:ameen/ui/widgets/bottom_navigation.dart';
import 'package:ameen/ui/widgets/choice_card.dart';
import 'package:ameen/ui/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(222, 222, 222, 1),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                _sliverAppBar(),
              ];
            },
            body: TabBarView(
              children: choices.map((Choice choice) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ChoiceCard(choice: choice),
                );
              }).toList(),
            ),
          ),
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
        labelColor: cGreen,
        indicatorColor: cGreen,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: TextStyle(
          fontSize: 13.0,
          fontFamily: 'Dubai',
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            text: "الأدعية المحفوظة",
          ),
          Tab(
            text: "المنشورات",
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
      leading: GestureDetector(
        onTap: () {},
        child: IconButton(
          icon: Image.asset(
            'images/settings-52x52.png',
            width: 20.0,
            height: 20.0,
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Image.asset(
            'images/arrow_back.png',
            width: 20.0,
            height: 20.0,
          ),
        ),
      ],
    );
  }

  Widget _horizontalLine() =>
      Container(
        height: 1.0,
        margin: EdgeInsets.symmetric(vertical: 10),
        color: Colors.grey.shade300,
      );
}
