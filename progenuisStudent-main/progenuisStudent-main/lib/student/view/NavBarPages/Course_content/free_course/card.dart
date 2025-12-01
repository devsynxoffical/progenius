import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:progenius/student/model/course_model/course_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/chapters.dart';

class FreeCourseCard extends StatelessWidget {
  final FreeCourse? course;

  const FreeCourseCard({required this.course, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (course == null) return const SizedBox.shrink(); // ✅ Avoid unnecessary rendering

    return InkWell(
      onTap: () {
        Get.to(() => ChapterScreen(
              courseId: course!.id!,
              courseImage: course!.courseImage!,
              courseTitle: course!.title!,
              destination: course!.destination!,
            ));
      },
      child: SizedBox(
        height: 90, // ✅ Fixed height for efficiency
        child: Card(
          elevation: 2,
          color: AppColors.whitColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: _buildCourseImage(),
            title: Text(
              course!.title ?? "No Title",
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            
            subtitle:course!.status == "UNPAID"?Text('Free Course',style: TextStyle(fontSize: 10),): _buildSubtitle(),
          ),
        ),
      ),
    );
  }

  /// ✅ Optimized Course Image Widget
  Widget _buildCourseImage() {
    if (course?.courseImage?.isNotEmpty == true && course?.destination?.isNotEmpty == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: "${ApiUrls.file}/${course!.destination}/${course!.courseImage}",
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        ),
      );
    }
    return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
  }

  /// ✅ Optimized Subtitle (Description + Students Count)
  Widget _buildSubtitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${course?.description ?? "No Description"} ',
            style: const TextStyle(fontSize: 10), 
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
       
        Text(
          '|   Students: (${course?.students?.length ?? 0})',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold,color: AppColors.secondary),
          
          overflow: TextOverflow.ellipsis,
        ),
        
      ],
    );
  }
}
