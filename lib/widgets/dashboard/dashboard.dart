import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/screens/dashboard/account/account.dart';
import 'package:quickfix_app/screens/dashboard/account/profile.dart';
import 'package:quickfix_app/screens/dashboard/home/home.dart';
import 'package:quickfix_app/screens/dashboard/orders/orders.dart';
import 'package:quickfix_app/screens/dashboard/pocket/pocket.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  // final PreferenceManager prefManager;
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  Widget currentScreen = Home();
  int _currentIndex = 0;
  String token = '';
  final _controller = Get.find<StateController>();
  // PersistentTabController _tabController =
  //     PersistentTabController(initialIndex: 0);

  DateTime pre_backpress = DateTime.now();

  final timegap = DateTime.now().difference(DateTime.now());

  _init() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      token = _prefs.getString("accessToken") ?? "";

      if (token.isNotEmpty) {
        APIService().getProfileStreamed(accessToken: token).listen((onData) {
          // debugPrint("LISTENED USER PROFILE ::: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            _controller.userData.value = map['user'];
          }
        });

        final bannersResp = await APIService().getBanners(accessToken: token);
        // debugPrint("BANNERS DASHBOARD DATA ::--:: ${bannersResp.body}");
        if (bannersResp.statusCode >= 200 && bannersResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(bannersResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          _controller.banners.value = maps;
        }

        final locationsResp =
            await APIService().getLocations(accessToken: token);
        // debugPrint("LOCATIONS LISTEN DATA ::--:: ${locationsResp.body}");
        if (locationsResp.statusCode >= 200 &&
            locationsResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(locationsResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          // debugPrint("LOCATION DASH MAPPED ::: $maps");
          _controller.locations.value = maps;
        }

        final expressResp =
            await APIService().getExpressFees(accessToken: token);
        // debugPrint("EXPRESS DASHBOARD DATA ::--:: ${expressResp.body}");
        if (expressResp.statusCode >= 200 && expressResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(expressResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          // debugPrint("EXPRESS DASH MAPPED ::: $maps");
          _controller.expressFeeList.value = maps;
        }

        final laundryServicesResp = await APIService()
            .getServicesCategorized(category: 'laundry', accessToken: token);
        // debugPrint("LAUNDRY SERVICES STATE ::--:: ${laundryServicesResp.body}");
        if (laundryServicesResp.statusCode >= 200 &&
            laundryServicesResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(laundryServicesResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          _controller.laundryServices.value = maps;
        }

        final cleaningServicesResp = await APIService()
            .getServicesCategorized(category: 'cleaning', accessToken: token);
        // debugPrint(
        //     "CLEANING SERVICES STATE ::--:: ${cleaningServicesResp.body}");
        if (cleaningServicesResp.statusCode >= 200 &&
            cleaningServicesResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(cleaningServicesResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          _controller.cleaningServices.value = maps;
        }

        final carwashServicesResp = await APIService()
            .getServicesCategorized(category: 'car_wash', accessToken: token);
        // debugPrint(
        // "CAR WASH SERVICES STATE ::--:: ${carwashServicesResp.body}");
        if (carwashServicesResp.statusCode >= 200 &&
            carwashServicesResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(carwashServicesResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          _controller.carwashServices.value = maps;
        }

        final socialsResp = await APIService().getSocials(accessToken: token);
        // debugPrint("SOCIALS DASHBOARD DATA ::--:: ${socialsResp.body}");
        if (socialsResp.statusCode >= 200 && socialsResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(socialsResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          _controller.socials.value = maps;
        }

        final ordersResp = await APIService().getOrders(accessToken: token);
        // debugPrint("ORDERS DASHBOARD DATA ::--:: ${ordersResp.body}");
        if (ordersResp.statusCode >= 200 && ordersResp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(ordersResp.body);
          _controller.orders.value = map['data'];
          _controller.ordersCurrentPage.value =
              int.parse("${map['currentPage']}");
          _controller.ordersTotalPages.value = map['totalItems'];
        }

        APIService()
            .getNotificationsStreamed(accessToken: token, page: 1)
            .listen((onData) {
          // debugPrint("LISTENED USER NOTIFICATIONS ::: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            _controller.notifications.value = map['data'];
            _controller.notificationCurrentPage.value =
                int.parse("${map['currentPage']}");
            _controller.notificationTotalPages.value = map['totalItems'];
          }
        });

        APIService()
            .getTransactionsStreamed(accessToken: token, page: 1)
            .listen((onData) {
          debugPrint(
              "LISTENED TRANSACTIONS DASHBOARD STREAMED ::: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            _controller.transactions.value = map['data'];
            _controller.transactionCurrentPage.value =
                int.parse("${map['currentPage']}");
            _controller.transactionTotalPages.value = map['totalItems'];
          }
        });

        APIService()
            .getTrackableOrdersStreamed(
          accessToken: token,
          page: 1,
        )
            .listen((onData) {
          debugPrint("LISTENED TRACKABLE ORDERS  ::: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            _controller.trackableOrders.value = map['data'];
            _controller.trackableOrdersCurrentPage.value =
                int.parse("${map['currentPage']}");
            _controller.trackableOrdersTotalPages.value = map['totalItems'];
          }
        });

        // APIService()
        //     .getServiceCategorizedStreamed(
        //         accessToken: token, category: 'cleaning')
        //     .listen((onData) {
        //   debugPrint("LISTENED CLEANING SERVICES  ::: ${onData.body}");
        //   if (onData.statusCode >= 200 && onData.statusCode <= 299) {
        //     List<Map<String, dynamic>> map = jsonDecode(onData.body);
        //     _controller.cleaningServices.value = map;
        //   }
        // });

        // APIService()
        //     .getServiceCategorizedStreamed(
        //         accessToken: token, category: 'car_wash')
        //     .listen((onData) {
        //   debugPrint("LISTENED CAR WASH SERVICES  ::: ${onData.body}");
        //   if (onData.statusCode >= 200 && onData.statusCode <= 299) {
        //     List<Map<String, dynamic>> map = jsonDecode(onData.body);
        //     _controller.carwashServices.value = map;
        //   }
        // });
      }
    } catch (e) {
      debugPrint("DASHBOARD INIT ERROR :::  $e");
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (!_controller.userData.value['is_profile_set']) {
        Get.to(
          ProfileScreen(
            isDirect: true,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const SizedBox(),
        child: Scaffold(
          body: PersistentTabView(
            context,
            controller: _controller.tabController,
            onItemSelected: (value) => _controller.selectedIndex.value = value,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineToSafeArea: true,
            backgroundColor: Constants.secondaryColor,
            handleAndroidBackButtonPress: false, // Default is true.
            resizeToAvoidBottomInset: true,
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardAppears: true,
            popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
            decoration: const NavBarDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              colorBehindNavBar: Color(0xFFFCFBFB),
            ),
            onWillPop: (final context) async {
              final timegap = DateTime.now().difference(pre_backpress);
              final cantExit = timegap >= const Duration(seconds: 4);
              pre_backpress = DateTime.now();
              if (cantExit) {
                Fluttertoast.showToast(
                    msg: "Press again to exit",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.grey[800],
                    textColor: Colors.white,
                    fontSize: 16.0);

                return false; // false will do nothing when back press
              } else {
                // _controller.setIsLoading(true);
                if (Platform.isAndroid) {
                  exit(0);
                } else if (Platform.isIOS) {}
                return true;
              }
            },
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                duration: Duration(milliseconds: 300),
                screenTransitionAnimationType:
                    ScreenTransitionAnimationType.fadeIn,
              ),
              onNavBarHideAnimation: OnHideAnimationSettings(
                duration: Duration(milliseconds: 100),
                curve: Curves.bounceInOut,
              ),
            ),
            navBarStyle: NavBarStyle.style1,
          ),
        ),
      );
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/home.svg',
          width: 18,
          height: 18,
          color: _controller.selectedIndex.value == 0
              ? Constants.primaryColorDark
              : Colors.grey,
        ),
        title: ("Home"),
        activeColorPrimary: Constants.primaryColorDark,
        inactiveColorPrimary: Colors.grey,
        iconSize: 18,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/orders.svg',
          width: 18,
          height: 18,
          color: _controller.selectedIndex.value == 1
              ? Constants.primaryColorDark
              : Colors.grey,
        ),
        title: ("Orders"),
        activeColorPrimary: Constants.primaryColorDark,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/pocket.svg',
          width: 18,
          height: 18,
          color: _controller.selectedIndex.value == 2
              ? Constants.primaryColorDark
              : Colors.grey,
        ),
        title: ("Pocket"),
        activeColorPrimary: Constants.primaryColorDark,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/account.svg',
          width: 18,
          height: 18,
          color: _controller.selectedIndex.value == 3
              ? Constants.primaryColorDark
              : Colors.grey,
        ),
        title: ("Account"),
        activeColorPrimary: Constants.primaryColorDark,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [Home(), Orders(), const Pocket(), AccountScreen()];
  }
}
