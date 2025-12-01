import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:progenuisadmin/model/dashborad/dashboard_model.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: controller.loadStudentStats,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards Row
                Row(
                  children: [
                    _buildSummaryCard(
                      'Total Students',
                      controller.studentStats.value.totalStudents.toString(),
                      Colors.blue,
                      Icons.people,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      'Premium Students',
                      controller.studentStats.value.premiumStudents.toString(),
                      Colors.green,
                      Icons.verified_user,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      'Free Students',
                      controller.studentStats.value.freeStudents.toString(),
                      Colors.orange,
                      Icons.person_outline,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Distribution Title
                const Text(
                  'Student Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Pie Chart and Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: SfCircularChart(
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          series: <CircularSeries>[
                            PieSeries<PieData, String>(
                              dataSource: controller.studentStats.value.toPieData(),
                              xValueMapper: (PieData data, _) => data.label,
                              yValueMapper: (PieData data, _) => data.value,
                              pointColorMapper: (PieData data, _) => data.color,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                              ),
                              animationDuration: 1000,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Progress indicators
                      _buildProgressIndicator(
                        'Premium Students',
                        controller.premiumPercentage,
                        Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildProgressIndicator(
                        'Free Students',
                        controller.freePercentage,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Your existing _buildSummaryCard and _buildProgressIndicator methods
  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}