import 'package:ameen/helpers/ui/app_color.dart' as myColors;
import 'package:ameen/ui/Screens/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



/// This Class to represent the Widget of Adding comment Rectangle beside the Profile Picture
/// of the user and *Redirect* him to Post Page..
///                           Y.G

class AddNewPostWidget extends StatelessWidget {
  final String hintText = "انشر الدعاء الذي تتمنى أن يتحقق ";
  final Color color =  Colors.black;
  AddNewPostWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1.0),
            blurRadius: 1.0, // has the effect of softening the shadow
            offset: new Offset(1.0, 1.0),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child:InkWell(
                onTap:() { /* When Tapped on Container Redirect User to Creating Post Screen to Write post  */
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePost(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(18),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.black12)
                    ),
                  child: Text(
                    hintText,
                    style: TextStyle(fontFamily: 'Dubai', fontSize: 12, height: 1.0, color: Colors.black38),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,

                  ),
                  ),
                ),
              ),
          Container(
            width: 55,
            height: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person_test.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
