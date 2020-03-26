import 'package:ameen/blocs/models/choice.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
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
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListView(
                    children: <Widget>[
                      PostWidget(
                        name: "محمد أحمد",
                        time: "12:20",
                        image: AssetImage("assets/images/person_test.png"),
                        content:
                            "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                      ),
                      PostWidget(
                        name: "محمد أحمد",
                        time: "12:20",
                        image: AssetImage("assets/images/person_test.png"),
                        content:
                            "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                      ),
                      PostWidget(
                        name: "محمد أحمد",
                        time: "12:20",
                        image: AssetImage("assets/images/person_test.png"),
                        content:
                            "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
                      ),
                    ],
                  ),
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
