import 'package:ameen/demo_values.dart';
import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/widgets/custom_app_bar.dart';
import 'package:ameen/ui/widgets/post_widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.cBackground,
      appBar: CustomAppBar(),
      body: ListView.builder(
          itemCount: DemoValues.posts.length,
          itemBuilder: (BuildContext context, int index){
            return PostWidget(postModel: DemoValues.posts[index]);
          }
       ),
    );
  }
}
