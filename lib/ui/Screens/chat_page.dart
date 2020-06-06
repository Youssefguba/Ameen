import 'package:ameencommon/utils/constants.dart';
import 'package:ameen/ui/widgets/chat_widgets/received_message_widget.dart';
import 'package:ameen/ui/widgets/chat_widgets/sended_message_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String username;

  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  var childList = <Widget>[];

  ChatPage({Key key, this.username}) : super(key: key);


  @override
  void initState() {
    childList.add(Align(
        alignment: Alignment(0, 0),
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 25,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
          child: Center(
              child: Text(
                "Today",
                style: TextStyle(fontSize: 11),
              )),
        )));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'Hello',
        time: '21:36 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'السلام عليكم ورحمة الله وبركاته',
        time: '21:36 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: ReceivedMessageWidget(
        content: 'Hello, Mohammad.I am fine. How are you?',
        time: '22:40 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content:
        'I am good. Can you do something for me? I need your help my bro.',
        time: '22:40 PM',
      ),
    ));
    childList.add(Align(
        alignment: Alignment(0, 0),
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 25,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
          child: Center(
              child: Text(
                "Today",
                style: TextStyle(fontSize: 11),
              )),
        )));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'Hello',
        time: '21:36 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'How are you? What are you doing?',
        time: '21:36 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: ReceivedMessageWidget(
        content: 'Hello, Mohammad.I am fine. How are you?',
        time: '22:40 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content:
        'I am good. Can you do something for me? I need your help my bro.',
        time: '22:40 PM',
      ),
    ));
    childList.add(Align(
        alignment: Alignment(0, 0),
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 25,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
          child: Center(
              child: Text(
                "Today",
                style: TextStyle(fontSize: 11),
              )),
        )));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'Hello',
        time: '21:36 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'How are you? What are you doing?',
        time: '21:36 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: ReceivedMessageWidget(
        content: 'Hello, Mohammad.I am fine. How are you?',
        time: '22:40 PM',
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content:
        'I am good. Can you do something for me? I need your help my bro.',
        time: '22:40 PM',
      ),
    ));
  }

//  @override
//  void dispose() {
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    child: Container(
                      color: MyColors.green[800],
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[

                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                username ?? "محمد أحمد",
                                style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Dubai'),
                              ),
                              Text(
                                "نشط الآن",
                                style: TextStyle(color: Colors.white60, fontSize: 12, fontFamily: 'Dubai'),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Container(
                              child: ClipRRect(
                                child: Container(
                                    child: SizedBox(
                                      child: Image.asset(
                                        "assets/images/person_test.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    color: Colors.transparent),
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              height: 50,
                              width: 50,
                              padding: const EdgeInsets.all(0.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  Flexible(

                    fit: FlexFit.tight,
                    // height: 500,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          // reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: childList,
                          )),
                    ),
                  ),
                  Divider(height: 0, color: Colors.black26),
                  // SizedBox(
                  //   height: 50,
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x59DEDEDE),
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLines: 20,
                        showCursor: true,
                        cursorColor: MyColors.green[900],
                        controller: _text,
                        decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.send, color: MyColors.green[800],),
                            onPressed: () {},
                          ),
                          border: InputBorder.none,
                          hintText: " ... أكتب رسالتك ",

                          hintStyle: TextStyle(
                            fontFamily: 'Dubai',
                          ),

                        ),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
