import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quickfix_app/helper/preference/preference_manager.dart';
import 'package:quickfix_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateController extends GetxController {
  // Dao? myDao;

  // StateController();

  PreferenceManager? manager;

  var isAppClosed = false;
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var hasInternetAccess = true.obs;

  var croppedPic = "".obs;
  var croppedProof = "".obs;
  var customSearchBar = [].obs;

  var productsData = "".obs;
  var services = [].obs;
  var laundryServices = [].obs;
  var cleaningServices = [].obs;
  var carwashServices = [].obs;
  var nextofKin = {}.obs;
  var notifications = [].obs;
  var referrals = [].obs;
  var interests = {}.obs;
  var userData = {}.obs;
  var banners = [].obs;
  var locations = [].obs;
  var transactions = [].obs;
  var orders = [].obs;
  var trackableOrders = [].obs;
  var settings = {}.obs;
  RxList socials = [].obs;
  RxList itemsList = [].obs;
  RxList itemsSelectedList = [].obs;

  RxList expressFeeList = [].obs;

  RxString selectedLocation = ''.obs;

  RxInt notificationCurrentPage = 1.obs;
  RxInt notificationTotalPages = 1.obs;

  RxInt transactionCurrentPage = 1.obs;
  RxInt transactionTotalPages = 1.obs;

  RxInt ordersCurrentPage = 1.obs;
  RxInt ordersTotalPages = 1.obs;

  RxInt trackableOrdersCurrentPage = 1.obs;
  RxInt trackableOrdersTotalPages = 1.obs;

  var searchData = [].obs;
  ScrollController transactionsScrollController = ScrollController();
  ScrollController messagesScrollController = ScrollController();

  var accessToken = "".obs;
  String _token = "";
  RxString dbItem = 'Awaiting data'.obs;
  PersistentTabController tabController =
      PersistentTabController(initialIndex: 0);

  @override
  void onInit() async {
    super.onInit();

    final _prefs = await SharedPreferences.getInstance();
    // var user = _prefs.getString("user") ?? "{}";
    var _token = _prefs.getString("accessToken") ?? "";
    debugPrint("ACCESS TOKEN :: $_token");

    try {
      final settingsResp = await APIService().getSettings();
      debugPrint("PLATFORM SETTINGS  ::--:: ${settingsResp.body}");
      if (settingsResp.statusCode >= 200 && settingsResp.statusCode <= 299) {
        List<dynamic> decodedJson = jsonDecode(settingsResp.body);
        List<Map<String, dynamic>> maps =
            decodedJson.map((e) => e as Map<String, dynamic>).toList();
        debugPrint("SETTINGS ITEM CHECKIFY ::: ${maps[0]}");
        settings.value = maps[0];
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (_token.isNotEmpty) {
      // Get User Profile
      try {
        final resp = await APIService().getProfile(accessToken: _token);
        debugPrint("PROFILE  ::--:: ${resp.body}");
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          userData.value = map['user'];
        }

        final notificationResp =
            await APIService().getNotifications(page: 1, accessToken: _token);
        debugPrint("NOTIFICATIONS ::--:: ${notificationResp.body}");
        if (notificationResp.statusCode >= 200 &&
            notificationResp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(notificationResp.body);
          notifications.value = map['data'];
          notificationCurrentPage.value = int.parse("${map['currentPage']}");
          notificationTotalPages.value = map['totalItems'];
        }

        final laundryServicesResp = await APIService()
            .getServicesCategorized(category: 'laundry', accessToken: _token);
        debugPrint("LAUNDRY SERVICES STATE ::--:: ${laundryServicesResp.body}");
        if (laundryServicesResp.statusCode >= 200 &&
            laundryServicesResp.statusCode <= 299) {
          List<Map<String, dynamic>> maps =
              jsonDecode(laundryServicesResp.body);
          laundryServices.value = maps;
        }

        final cleaningServicesResp = await APIService()
            .getServicesCategorized(category: 'cleaning', accessToken: _token);
        debugPrint(
            "CLEANING SERVICES STATE ::--:: ${cleaningServicesResp.body}");
        if (cleaningServicesResp.statusCode >= 200 &&
            cleaningServicesResp.statusCode <= 299) {
          List<Map<String, dynamic>> maps =
              jsonDecode(cleaningServicesResp.body);
          cleaningServices.value = maps;
        }

        final carwashServicesResp = await APIService()
            .getServicesCategorized(category: 'car_wash', accessToken: _token);
        debugPrint(
            "CAR WASH SERVICES STATE ::--:: ${carwashServicesResp.body}");
        if (carwashServicesResp.statusCode >= 200 &&
            carwashServicesResp.statusCode <= 299) {
          List<Map<String, dynamic>> maps =
              jsonDecode(carwashServicesResp.body);
          carwashServices.value = maps;
        }

        final bannersResp = await APIService().getBanners(accessToken: _token);
        debugPrint("BANNERS STATE DATA ::--:: ${bannersResp.body}");
        if (bannersResp.statusCode >= 200 && bannersResp.statusCode <= 299) {
          List<Map<String, dynamic>> map = jsonDecode(bannersResp.body);
          banners.value = map;
        }

        final socialResp = await APIService().getSocials(accessToken: _token);
        debugPrint("REFERRALS STATE DATA ::--:: ${socialResp.body}");
        if (socialResp.statusCode >= 200 && socialResp.statusCode <= 299) {
          List<Map<String, dynamic>> map = jsonDecode(socialResp.body);
          socials.value = map;
        }

        final locationsResp =
            await APIService().getLocations(accessToken: _token);
        debugPrint("LOCATIONS STATE DATA ::--:: ${locationsResp.body}");
        if (locationsResp.statusCode >= 200 &&
            locationsResp.statusCode <= 299) {
          // List<Map<String, dynamic>> map = jsonDecode(locationsResp.body);
          // locations.value = map;

          List<dynamic> decodedJson = jsonDecode(locationsResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          debugPrint("LOCATION MAPPED ::: $maps");
          locations.value = maps;
        }

        final reasonsResp = await APIService().getBanners(accessToken: _token);
        debugPrint("REASONS STATE DATA ::--:: ${reasonsResp.body}");
        if (reasonsResp.statusCode >= 200 && reasonsResp.statusCode <= 299) {
          List<Map<String, dynamic>> map = jsonDecode(reasonsResp.body);
          banners.value = map;
        }

        final expressResp =
            await APIService().getExpressFees(accessToken: _token);
        debugPrint("EXPRESS DELIVERIES STATE DATA ::--:: ${expressResp.body}");
        if (expressResp.statusCode >= 200 && expressResp.statusCode <= 299) {
          List<dynamic> decodedJson = jsonDecode(expressResp.body);
          List<Map<String, dynamic>> maps =
              decodedJson.map((e) => e as Map<String, dynamic>).toList();
          debugPrint("EXPRESS FEES MAPPED ::: $maps");
          expressFeeList.value = maps;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Widget currentScreen = const SizedBox();

  var currentPage = "Home";
  List<String> pageKeys = [
    "Home",
    "Categories",
    "Promos",
  ];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Categories": GlobalKey<NavigatorState>(),
    "Promos": GlobalKey<NavigatorState>(),
  };

  var selectedIndex = 0.obs; //Bottom Navigation Dashboard tab

  setUserData(var value) {
    if (value != null) {
      userData.value = value;
    }
  }

  setNextofKinData(var value) {
    if (value != null) {
      nextofKin.value = value;
    }
  }

  setSearchData(var data) {
    searchData.value.add(data);
  }

  void setAccessToken(String token) {
    accessToken.value = token;
  }

  void setHasInternet(bool state) {
    hasInternetAccess.value = state;
  }

  void jumpTo(int pos) {
    // tabController.jumpToTab(pos);
  }

  setLoading(bool state) {
    isLoading.value = state;
  }

  void resetAll() {}

  void incrementQuantity(
    int index,
  ) {
    itemsList.value[index].quantity++;
    itemsList.refresh();
  }

  void decrementQuantity(int index) {
    if (itemsList.value[index].quantity > 0) {
      itemsList.value[index].quantity--;
      itemsList.refresh();
    }
  }

  // Get total price
  double get totalPrice => itemsList.value
      .map((item) => item.price * item.quantity)
      .fold(0, (previousValue, element) => previousValue + element);

  @override
  void onClose() {
    super.onClose();
    transactionsScrollController.dispose();
    messagesScrollController.dispose();
  }
}
