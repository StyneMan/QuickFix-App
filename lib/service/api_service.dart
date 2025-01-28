import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:quickfix_app/helper/constants/constants.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/interceptors/api_interceptors.dart';
import '../helper/interceptors/token_retry.dart';

class APIService {
  final _controller = Get.find<StateController>();
  http.Client client = InterceptedClient.build(
    interceptors: [
      MyApiInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  APIService() {
    // init();
  }

  // Define a StreamController
  final StreamController<http.Response> _streamController =
      StreamController<http.Response>();

  Future<http.Response> signup(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/auth/signup'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> login(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/auth/login'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> checkInternet() async {
    return await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/1'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> forgotPass(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/auth/forgot-password'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyAccount({required Map body}) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/auth/verify'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resendOTP({required Map body}) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/auth/resend-otp'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyForgotPassOTP({required Map body}) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/auth/verify-forgot-password'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resetPass({required Map body}) async {
    return await http.put(
      Uri.parse('${Constants.baseURL}/api/v1/auth/reset-password'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Stream<http.Response> getProfileStreamed({
    required String accessToken,
  }) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/api/v1/users/profile'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getProfile({required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/users/profile'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Stream<http.Response> getNotificationsStreamed(
      {required int page, required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/api/v1/users/notifications?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getNotifications(
      {required int page, required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/users/notifications?page=$page'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Stream<http.Response> getServiceStreamed(
      {required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/api/v1/services/all'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getServices({required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/services/all'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Stream<http.Response> getServiceCategorizedStreamed(
      {required String category, required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constants.baseURL}/api/v1/services/categorized?category=$category'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getTransactionsStreamed(
      {required int page, required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constants.baseURL}/api/v1/transactions/user/all?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getServicesCategorized(
      {required String category, required String accessToken}) async {
    return await client.get(
      Uri.parse(
          '${Constants.baseURL}/api/v1/services/categorized?category=$category'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> initTransaction(
      {required Map body, required String accessToken}) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/api/v1/transactions/initialize'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> updateProfile(
      {required Map body, required String accessToken}) async {
    return await http.put(
      Uri.parse('${Constants.baseURL}/api/v1/users/update'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> createOrder({
    required Map body,
    required String accessToken,
  }) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/transactions/create'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  // Future<http.Response> getNextofKin(
  //     {required String userId, required String accessToken}) async {
  //   return await client.get(
  //     Uri.parse('${Constants.baseURL}/api/v1/users/$userId/nextofkin/info'),
  //     headers: {
  //       "Content-type": "application/json",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //   );
  // }

  // Future<http.Response> getReferrals({required String accessToken}) async {
  //   return await client.get(
  //     Uri.parse('${Constants.baseURL}/api/v1/users/referrals'),
  //     headers: {
  //       "Content-type": "application/json",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //   );
  // }

  Future<http.Response> getSocials({required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/admins/socials/all'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Stream<http.Response> getSocialsStreamed(
      {required int page, required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/api/v1/admins/socials/all'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getBanners({required String accessToken}) async {
    final prf = await SharedPreferences.getInstance();
    final token = prf.getString('accessToken');
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/admins/banners/active/all'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<http.Response> getLocations({required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/locations/list'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> getExpressFees({required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/admins/express/all'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> getOrders({required String accessToken}) async {
    final prf = await SharedPreferences.getInstance();
    final token = prf.getString('accessToken');
    return await client.get(
      Uri.parse('${Constants.baseURL}/api/v1/orders/user/all'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  Stream<http.Response> getTrackableOrdersStreamed(
      {required int page, required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream

      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/api/v1/orders/user/trackables'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getSettings() async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/api/v1/admins/settings/all'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Stream<http.Response> getBannerStreamed(
      {required int page, required String accessToken}) async* {
    try {
      // Fetch data and add it to the stream

      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/api/v1/admins/banners/active/all'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> imagesUploader(
      {required String accessToken, required Map payload}) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}/api/v1/images/upload'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> bookAppointment(
      {required Map body,
      required String userId,
      required String accessToken}) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/users/$userId/appointment/book'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> changePassword(
      {required Map body, required String accessToken}) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/users/change-password'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> deleteAccount(
      {required Map body,
      required String userId,
      required String accessToken}) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/api/v1/users/$userId/account/delete'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }
}
