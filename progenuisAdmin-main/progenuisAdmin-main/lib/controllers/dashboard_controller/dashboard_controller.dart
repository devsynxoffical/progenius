import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/model/dashborad/dashboard_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';


class DashboardController extends GetxController {
  final studentStats = StudentStats(
    totalStudents: 0,
    premiumStudents: 0,
    freeStudents: 0,
  ).obs;
  final isLoading = false.obs;
  final Dio dio = Dio();

  @override
  void onInit() {
    loadStudentStats();
    super.onInit();
  }

  Future<void> loadStudentStats() async {
    isLoading.value = true;
    try {
      final response = await dio.get(ApiUrls.dashboard);
      print('API Response: ${response.data}'); // Debug print
      
      if (response.statusCode == 200) {
        studentStats.value = StudentStats.fromApiResponse(response.data);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      print('Error loading dashboard: $e');
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  double get premiumPercentage => studentStats.value.totalStudents == 0 
      ? 0 
      : studentStats.value.premiumStudents / studentStats.value.totalStudents;

  double get freePercentage => studentStats.value.totalStudents == 0
      ? 0
      : studentStats.value.freeStudents / studentStats.value.totalStudents;
}