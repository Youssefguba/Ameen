import 'package:ameen/ui/Screens/user_profile.dart';
import 'package:ameencommon/common_widget/refresh_progress_indicator.dart';
import 'package:ameencommon/models/user_data.dart';
import 'package:ameencommon/utils/constants.dart';
import 'package:ameencommon/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  FirebaseUser currentUser;
  String profileId;
  SearchPage({Key key, @required this.profileId, @required this.currentUser});


  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  String userId;

  @override
  void initState() {
  }

  _search(String query) {
    Future<QuerySnapshot> users = DbRefs.usersRef
        .where("username", isGreaterThanOrEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  _clearSearch() {
    searchController.clear();
    FocusScope.of(context).unfocus();

    return _noContent();
  }
  @override
  void dispose() {
    super.dispose();
    searchController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _searchField(),
      body: searchResultsFuture == null ? _noContent() : _showSearchResults(),
    );
  }

  Widget _showSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return RefreshProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          UserModel user = UserModel.fromDocument(doc);
          UserResult searchResult = UserResult(user, widget.currentUser);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  Widget _searchField() {
    return AppBar(
        backgroundColor: Colors.white,
        title: Container(
          height: 50,
          padding: EdgeInsets.only(right: 5, bottom: 2, top: 2, left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: TextFormField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: AppTexts.searchForFriends,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.person,
                size: 28.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => _clearSearch(),
              ),
            ),
            onFieldSubmitted: _search,
          ),
        ));
  }

  Widget _noContent() {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset('assets/images/user_search.png', height: 150,),

          ],
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final UserModel user;
  FirebaseUser currentUser;
  UserResult(this.user, this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0, top: 10),
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => pushPage(context, UserProfile(profileId: user.uid, currentUser: currentUser)),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: user.profilePicture == null ? AssetImage(AppIcons.AnonymousPerson) : CachedNetworkImageProvider(user.profilePicture),
                ),
                title: Text(
                  user.username,
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}

