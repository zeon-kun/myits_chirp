import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/keys.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/screens/ChatScreen/chat_list_screen.dart';
import 'package:wave/view/screens/CreatePostScreen/create_post_screen.dart';
import 'package:wave/view/screens/FeedScreen/feed_screen.dart';
import 'package:wave/view/screens/ProfileScreen/profile_screen.dart';
import 'package:wave/view/screens/SearchScreen/search_screen.dart';
import 'package:wave/view/screens/SpaceScreen/space_list.dart';
import 'package:wave/view/screens/SpaceScreen/space_detail_screen.dart';
import 'package:wave/view/screens/SpaceScreen/follower_list_screen.dart';

class HomeNavigationScreen extends StatefulWidget {
  HomeNavigationScreen({super.key});

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  final List<dynamic> screens = [
    const FeedScreen(),
    const SearchScreen(),
    CreatePostScreen(),
    ChatListScreen(),
    SpaceListScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();

    // Request permission for notifications (same as before)
  }

  @override
  Widget build(BuildContext context) {
    double bottomNavBarItemHeight = 25;
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      bottomNavigationBar: Consumer<HomeNavController>(
        builder: (context, homeNavController, child) {
          return BottomNavigationBar(
            key: const Key(Keys.keyForBottomNavButton),
            onTap: (newScreenIndex) {
              if (newScreenIndex == 2) {
                Get.toNamed(AppRoutes.createNewPostScreen);
              } else {
                Get.printInfo(info: "Selected $newScreenIndex index");
                homeNavController.setCurrentScreenIndex(newScreenIndex);
              }
            },
            elevation: 0,
            currentIndex: homeNavController.currentScreenIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue[900],
            showUnselectedLabels: false,
            selectedItemColor: CustomColor.primaryColor,
            showSelectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: CustomFont.poppins,
              letterSpacing: -0.1,
              fontSize: 10.5,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    (homeNavController.currentScreenIndex == 0)
                        ? CustomIcon.exploreIcon
                        : CustomIcon.exploreIcon,
                    key: const Key(Keys.keyForExploreIcon),
                    color: (homeNavController.currentScreenIndex == 0)
                        ? CustomColor.primaryColor
                        : null,
                    height: bottomNavBarItemHeight,
                  ),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    (homeNavController.currentScreenIndex == 1)
                        ? CustomIcon.searchIcon
                        : CustomIcon.searchIcon,
                    key: const Key(Keys.keyForSearchIcon),
                    color: (homeNavController.currentScreenIndex == 1)
                        ? CustomColor.primaryColor
                        : null,
                    height: bottomNavBarItemHeight,
                  ),
                ),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(
                    Icons.add,
                    key: const Key(Keys.keyForAddPostIcon),
                    color: (homeNavController.currentScreenIndex == 2)
                        ? CustomColor.primaryColor
                        : null,
                    size: bottomNavBarItemHeight,
                  ),
                ),
                label: "New",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    (homeNavController.currentScreenIndex == 3)
                        ? CustomIcon.chatIcon
                        : CustomIcon.chatIcon,
                    key: const Key(Keys.keyForChatIcon),
                    color: (homeNavController.currentScreenIndex == 3)
                        ? CustomColor.primaryColor
                        : null,
                    height: bottomNavBarItemHeight,
                  ),
                ),
                label: "Chat",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(
                    Icons.travel_explore,
                    key: const Key(Keys.keyForSearchIcon),
                    color: (homeNavController.currentScreenIndex == 4)
                        ? CustomColor.primaryColor
                        : null,
                    size: bottomNavBarItemHeight,
                  ),
                ),
                label: "Space",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    (homeNavController.currentScreenIndex == 5)
                        ? CustomIcon.profileIcon
                        : CustomIcon.profileIcon,
                    key: const Key(Keys.keyForProfileIcon),
                    color: (homeNavController.currentScreenIndex == 5)
                        ? CustomColor.primaryColor
                        : null,
                    height: bottomNavBarItemHeight,
                  ),
                ),
                label: "Profile",
              ),
            ],
          );
        },
      ),
      body: Consumer<HomeNavController>(
        builder: (context, homeNavController, child) {
          if (homeNavController.isFollowerScreen && homeNavController.detailScreenId != null) {
            return FollowerListScreen(spaceId: homeNavController.detailScreenId!);
          } else if (homeNavController.isDetailScreen && homeNavController.detailScreenId != null) {
            return SpaceDetailScreen(spaceId: homeNavController.detailScreenId!);
          } else {
            return screens[homeNavController.currentScreenIndex];
          }
        },
      ),
    );
  }
}