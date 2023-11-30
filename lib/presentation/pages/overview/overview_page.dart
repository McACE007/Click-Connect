import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/constants.dart';
import '../activity/activity_page.dart';
import '../home/home_page.dart';
import '../post/upload_post_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late PageController pageController;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: backGroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
              color: primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline,
              color: primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              color: primaryColor,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
      body: PageView(
        controller: pageController,
        children: [
          const HomePage(),
          SearchPage(currentUserUid: widget.uid),
          UploadPostPage(currentUserUid: widget.uid),
          const ActivityPage(),
          ProfilePage(
            currentUserUid: widget.uid,
          ),
        ],
      ),
    );
  }
}
