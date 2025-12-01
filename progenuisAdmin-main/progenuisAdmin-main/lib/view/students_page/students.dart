import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/student_controller/student_controller.dart';
import 'package:progenuisadmin/model/student_model/student_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';

class CustomerPage extends StatelessWidget {
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildCustomerList(),
          ),
        ],
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Students List',
        style: TextStyle(color: AppColors.whitColor),
      ),
          flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),),
      
      centerTitle: true,
      elevation: 0,
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (query) => customerController.filterStudents(query),
        decoration: InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  // Customer List
  Widget _buildCustomerList() {
    return Obx(() {
      if (customerController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (customerController.filteredCustomers.isEmpty) {
        return Center(
          child: Text(
            "No students found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: customerController.filteredCustomers.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          final customer = customerController.filteredCustomers[index];
          return _buildCustomerCard(context, customer);
        },
      );
    });
  }

  // Customer Card
Widget _buildCustomerCard(BuildContext context, Customer customer) {
  return Card(
    elevation: 0,
    color: AppColors.whitColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: const Color.fromARGB(255, 198, 200, 202)),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.all(8),
      leading: customer.profilePicture != null &&
              customer.profilePicture!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: "${ApiUrls.file}/${customer.destination}/${customer.profilePicture}",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
              ),
            )
          : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      title: Text(
        customer.fullName ?? "No Name",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customer.phoneNumber ?? "No Phone",
            style: TextStyle(color: Colors.grey[600],fontSize: 10),
          ),
          Text(
            customer.email ?? "No Email",
            style: TextStyle(color: Colors.grey[600],fontSize: 10),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
      
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmationDialog(context, customer);
              } 
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 5),
                      Text('Delete User', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              
              
              ];
            },
          ),
        ],
      ),
    
    
    ),
  );
}
  // Delete Confirmation Dialog
  void _showDeleteConfirmationDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to delete ${customer.fullName}?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                customerController.deleteCustomer(customer.id!);
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }
}