import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/navBar.dart';
import 'package:progenius/student/controller/edit_profile/edit_profile.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/widgets/custome_button.dart';
import 'package:progenius/widgets/custome_textfield.dart';

class EditProfilePage extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.to(() => MainNavigationPage()),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture with Background Header
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: controller.pickImage, // Pick image from gallery
                        child: Obx(() {
                          String? imageUrl;

                          // ✅ Show the newly selected image first
                          if (controller.selectedImage.value != null) {
                            return CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: FileImage(controller.selectedImage.value!),
                            );
                          }

                          // ✅ Check if profile data is available before accessing properties
                          if (profile != null && profile.profileImage != null && profile.profileImage!.isNotEmpty) {
                            // ✅ Construct Correct Image URL
                            imageUrl = '${ApiUrls.file}${profile.destination}${profile.profileImage}';
                            print("Profile Image URL: $imageUrl"); // ✅ Debugging output
                          }

                          return CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                              child: imageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) {
                                        print("Error loading image: $error");
                                        return Image.asset('assets/logo1.png');
                                      },
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                    )
                                  : Image.asset(
                                      'assets/logo1.png',
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                    ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 90),

              // Full Name Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextField(
                      hintText: "Full Name",
                      prefixIcon: Icons.person,
                      controller: controller.nameController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mobile Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: "Mobile",
                      prefixIcon: Icons.phone,
                      controller: controller.phoneController,
                    ),
                    if (controller.phoneError.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          controller.phoneError.value,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Email Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: "Email",
                      prefixIcon: Icons.email,
                      controller: controller.emailController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Update Button with Loading State
              Center(
                child: CustomButton(
                  text: 'Update',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.updateProfile,
                ),
              ),
              const SizedBox(height: 20), // Add some space at the bottom
            ],
          ),
        );
      }),
    );
  }
}

