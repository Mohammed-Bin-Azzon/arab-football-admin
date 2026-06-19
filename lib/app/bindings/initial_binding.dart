import 'package:get/get.dart';

import '../../core/network/api_client.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/auth_service.dart';

import '../../features/dashboard/dashboard_controller.dart';
import '../../features/dashboard/dashboard_service.dart';

import '../../features/matches/matches_controller.dart';
import '../../features/matches/matches_service.dart';

import '../../features/posts/posts_controller.dart';
import '../../features/posts/posts_service.dart';

import '../../features/reports/reports_controller.dart';
import '../../features/reports/reports_service.dart';

import '../../features/users/users_controller.dart';
import '../../features/users/users_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(
      ApiClient(),
      permanent: true,
    );

    Get.put<AuthService>(
      AuthService(Get.find<ApiClient>()),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(Get.find<AuthService>()),
      permanent: true,
    );

    Get.lazyPut<DashboardService>(
      () => DashboardService(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(Get.find<DashboardService>()),
      fenix: true,
    );

    Get.lazyPut<MatchesService>(
      () => MatchesService(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<MatchesController>(
      () => MatchesController(Get.find<MatchesService>()),
      fenix: true,
    );

    Get.lazyPut<PostsService>(
      () => PostsService(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<PostsController>(
      () => PostsController(Get.find<PostsService>()),
      fenix: true,
    );

    Get.lazyPut<UsersService>(
      () => UsersService(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<UsersController>(
      () => UsersController(Get.find<UsersService>()),
      fenix: true,
    );

    Get.lazyPut<ReportsService>(
      () => ReportsService(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<ReportsController>(
      () => ReportsController(Get.find<ReportsService>()),
      fenix: true,
    );
  }
}