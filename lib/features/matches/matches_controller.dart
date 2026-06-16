import 'dart:typed_data';

import 'package:get/get.dart';

import '../../core/models/paginated_result.dart';
import 'match_model.dart';
import 'matches_service.dart';

class MatchesController extends GetxController {
  MatchesController(this._service);

  final MatchesService _service;

  final matches = <MatchModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  int currentPage = 1;
  int pageSize = 10;
  int totalCount = 0;
  bool hasNextPage = false;

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
  }

  Future<void> fetchMatches({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getMatches(
        pageNumber: page,
        pageSize: pageSize,
      );

      final PaginatedResult<MatchModel>? result = response.data;

      if (result == null) {
        matches.clear();
        return;
      }

      matches.assignAll(result.items);
      currentPage = result.currentPage;
      totalCount = result.totalCount;
      hasNextPage = result.hasNextPage;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createMatch({
    required String homeTeam,
    required Uint8List homeTeamLogoBytes,
    required String homeTeamLogoName,
    required String awayTeam,
    required Uint8List awayTeamLogoBytes,
    required String awayTeamLogoName,
    required String league,
    required String matchDate,
    required int hour,
    required int minute,
    required String period,
  }) async {
    try {
      isSaving.value = true;

      await _service.createMatch(
        homeTeam: homeTeam,
        homeTeamLogoBytes: homeTeamLogoBytes,
        homeTeamLogoName: homeTeamLogoName,
        awayTeam: awayTeam,
        awayTeamLogoBytes: awayTeamLogoBytes,
        awayTeamLogoName: awayTeamLogoName,
        league: league,
        matchDate: matchDate,
        hour: hour,
        minute: minute,
        period: period,
      );

      await fetchMatches(page: 1);

      Get.snackbar(
        'نجاح',
        'تمت إضافة المباراة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateMatch({
    required int id,
    required String homeTeam,
    required String awayTeam,
    required String league,
    required String matchDate,
    required int hour,
    required int minute,
    required String period,
    Uint8List? homeTeamLogoBytes,
    String? homeTeamLogoName,
    Uint8List? awayTeamLogoBytes,
    String? awayTeamLogoName,
  }) async {
    try {
      isSaving.value = true;

      await _service.updateMatch(
        id: id,
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        league: league,
        matchDate: matchDate,
        hour: hour,
        minute: minute,
        period: period,
        homeTeamLogoBytes: homeTeamLogoBytes,
        homeTeamLogoName: homeTeamLogoName,
        awayTeamLogoBytes: awayTeamLogoBytes,
        awayTeamLogoName: awayTeamLogoName,
      );

      await fetchMatches(page: currentPage);

      Get.snackbar(
        'نجاح',
        'تم تعديل المباراة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteMatch(int id) async {
    try {
      isSaving.value = true;

      await _service.deleteMatch(id);
      await fetchMatches(page: currentPage);

      Get.snackbar(
        'نجاح',
        'تم حذف المباراة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> changeStatus({required int id, required int status}) async {
    try {
      isSaving.value = true;

      await _service.changeStatus(id: id, status: status);

      await fetchMatches(page: currentPage);

      Get.snackbar(
        'نجاح',
        'تم تحديث حالة المباراة',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> openPredictions(int id) async {
    try {
      isSaving.value = true;

      await _service.openPredictions(id);
      await fetchMatches(page: currentPage);

      Get.snackbar(
        'نجاح',
        'تم فتح التوقعات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> closePredictions(int id) async {
    try {
      isSaving.value = true;

      await _service.closePredictions(id);
      await fetchMatches(page: currentPage);

      Get.snackbar(
        'نجاح',
        'تم إغلاق التوقعات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
