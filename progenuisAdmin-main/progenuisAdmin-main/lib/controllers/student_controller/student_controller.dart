import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenuisadmin/model/student_model/student_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class CustomerController extends GetxController {
  var customers = <Customer>[].obs;
  var filteredCustomers = <Customer>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchCustomers();
    
    super.onInit();
  }

  // Fetch customers
  Future<void> fetchCustomers() async {
    String? token = await Sharedprefrence.getAccessToken();
    print("Access Token: $token");

    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.AallUser),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data']; // Extracting actual list
          customers.assignAll(data.map((json) => Customer.fromJson(json)).toList());
          filteredCustomers.assignAll(customers);
        } else {
          Get.snackbar("Error", "Invalid response format", snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        print("Response Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong!", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }


// allow dis allow

  // Allow/Disallow student
  Future<void> allowDisallowStudent(String studentId, bool allow) async {
    String? token = await Sharedprefrence.getAccessToken();
    try {
      print(studentId);
      print(allow);
      final response = await http.patch(
        Uri.parse("${ApiUrls.allowDisAllow}/$studentId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'hasAccess': allow, // Pass the boolean flag for allow or disallow
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update the local customer list based on success
    
        var customer = customers.firstWhere((element) => element.id == studentId);
        customer.hasAccess= allow;
        filteredCustomers.refresh();

        Get.snackbar("Success", allow ? "Student allowed" : "Student disallowed", snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar("Error", "Failed to update status", snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!", snackPosition: SnackPosition.TOP);
    }
  }



  // Delete customer by ID
  Future<void> deleteCustomer(String id) async {
    String? token = await Sharedprefrence.getAccessToken();
    print("Access Token: $token");

    try {
      final response = await http.delete(
        Uri.parse("${ApiUrls.AdeleteUser}/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Remove the customer from the local list
        customers.removeWhere((customer) => customer.id == id);
        filteredCustomers.removeWhere((customer) => customer.id == id);

        Get.snackbar("Success", "Customer deleted successfully", snackPosition: SnackPosition.TOP,);
      } else {
        print("Delete Error: ${response.body}");
        Get.snackbar("Error", "Failed to delete customer", snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong!", snackPosition: SnackPosition.TOP);
    }
  }

  // Filter students by name
  void filterStudents(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.assignAll(
        customers.where((customer) => customer.fullName!.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}