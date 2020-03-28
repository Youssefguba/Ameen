import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/news_feed_widgets/add_new_post_widget.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.cBackground,
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () {},
        color: myColors.green[800],
        child: Container(
          child: ListView(
            // To represent The List of Posts and Create Post Section
            children: <Widget>[
              AddNewPostWidget("أنشر دعاء ...", Colors.grey[200]),
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
              PostWidget(
                name: "محمد أحمد",
                time: "12:20",
                image: AssetImage("assets/images/person_test.png"),
                content:
                    "اللهم أنت ربي لا إلة الا انت خلقتني وانا عبدك وانا على عهدك ووعدك ما استطعت اعوذ بك من شر ما صنعت وأبوك لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
